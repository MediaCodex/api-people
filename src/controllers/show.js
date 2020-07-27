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
  const bySlug = !!ctx.query.slug
  const path = ctx.path.split('/')
  const id = path[path.length - 1]

  if (!id) {
    ctx.throw(400, `${bySlug ? 'Slug' : 'ID'} required`)
  }

  const person = await (bySlug ? Person.getBySlug(id) : Person.get(id))

  if (!person) {
    ctx.throw(404, 'Person not found')
  }

  ctx.body = person
  ctx.status = 200
}

/**
 * Wrap Koa in Lambda-compatible IO and export
 */
app.use(handler)
export default wrapper(app)
