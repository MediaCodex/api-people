import { lensPath, view } from 'ramda'

/**
 * @constant {R.lensPath} authorizerLens
 */
const authorizerLens = lensPath(['req', 'requestContext', 'authorizer', 'jwt'])

/**
 * Extract auth from AWS request context
 *
 * @param {import('koa').Context} context
 * @param {import('koa').Next} next
 */
export default async (ctx, next) => {
  if (process.env.NODE_ENV === 'local') {
    Object.assign(ctx.state, { userId: '000000000', name: 'Example User' })
    await next()
    return
  }

  const authorizer = view(authorizerLens, ctx)
  if (!authorizer) ctx.throw(401, 'Authorizer not present')

  const claims = authorizer.claims
  if (!claims) ctx.throw(401, 'Missing authorizer claims')
  Object.assign(ctx.state, { userId: claims.sub, name: claims.name })

  const scopes = authorizer.scopes
  if (scopes) ctx.state.scopes = scopes

  await next()
}
