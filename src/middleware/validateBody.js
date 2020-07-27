/**
 * Validate request body, or return validation-failed response
 *
 * @param {import('@hapi/joi').Schema} schema
 * @param {import('@hapi/joi').ValidationOptions} options
 * @returns {import('koa').Middleware}
 */
export default (schema, options) => async function validator (ctx, next) {
  let validated; try {
    validated = await schema.validateAsync(ctx.request.body, { abortEarly: false, stripUnknown: true, ...options })
  } catch (error) {
    if (error.name !== 'ValidationError') throw error
    const removeValues = (field) => { delete field.context.value; return field }
    error.details.map(removeValues)
    ctx.body = { error: 'ValidationError', fields: error.details }
    ctx.status = 400
    return
  }

  ctx.request.body = validated
  await next()
}
