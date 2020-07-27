import jsonError from 'koa-json-error'
import { omit, compose, evolve, ifElse, split } from 'ramda'

/**
 * Format error as JSON, omit stacktrace in prod
 *
 * @param {Boolean} [isProd]
 */
export default (isProd = true) => jsonError({
  postFormat: (e, obj) => {
    const remove = omit(['stack'])
    const toObj = compose((arr) => ({ ...arr }), split('\n    '))
    const format = evolve({ stack: toObj })
    return ifElse(isProd, remove, format)(obj)
  }
})
