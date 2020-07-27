import serverless from 'serverless-http'
import { customAlphabet } from 'nanoid'
import nolookalikes from 'nanoid-dictionary/nolookalikes'

/**
 * Either return an AWS Lambda handler or init
 * a local instance, depending on NODE_ENV
 *
 * @param {import('koa').Koa} app Koa application
 */
export const wrapper = (app) => {
  const environment = process.env.NODE_ENV || 'local'

  if (environment !== 'local') {
    // wrap koa for lambda
    return async (event, context) => {
      return serverless(app)(event, context)
    }
  }

  app.listen(3000)
  console.info('listening at http://127.0.0.1:3000')
}

/**
 * Generate a short ID for use as a primary key
 *
 * @returns {string}
 */
export const nanoid = customAlphabet(nolookalikes, 10)
