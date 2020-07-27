import Koa from 'koa'
import { wrapper } from '../helpers'
import { applyDefaults } from '../middleware'
import Person from '../models/person'

/**
 * Initialise Koa
 */
const app = new Koa()
applyDefaults(app)

/**
 * Function logic
 *
 * @param {Koa.Context} ctx
 */
const handler = async (ctx) => {
  // get params from query, or headers, or default value
  const rawLimit = ctx.query.limit || ctx.request.get('X-Pagination-Limit') || 50
  const token = ctx.query.token || ctx.request.get('X-Pagination-Token') || undefined

  // parse limit and check not too high
  const limit = Number.parseInt(rawLimit, 10)
  if (Number.isNaN(limit) || limit > 1000) {
    ctx.throw(400, 'Limit is too high, or NaN')
  }

  // list all people
  const query = Person.scan().limit(limit)
  if (token) query.lastKey(token)
  const people = await query.exec()

  // set pagination headers
  ctx.set('X-Pagination-Count', people.count)
  ctx.set('X-Pagination-Token', people.lastKey)

  // return data
  ctx.body = people
  ctx.status = 200
}

/**
 * Wrap Koa in Lambda-compatible IO and export
 */
app.use(handler)
export default wrapper(app)
