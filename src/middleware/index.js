import jsonError from './jsonError'

/**
 * Apply default middlewares
 *
 * @param {import('koa').Koa} app
 */
export const applyDefaults = (app) => {
  const isProd = () => process.env.NODE_ENV === 'production'
  app.use(jsonError(isProd))
}

// re-export middelwares that don't require modification
export { default as validateBody } from './validateBody'
export { default as auth } from './auth'
