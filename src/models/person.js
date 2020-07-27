import dynamoose from 'dynamoose'

/**
 * Attribute definitions
 *
 * NOTE: validation not included since all fields are assumed
 * to have been validated at the controller level.
 *
 * @constant {object} schemaAttributes
 */
const schemaAttributes = {
  id: {
    type: String,
    hashKey: true,
    required: true
  },
  slug: {
    type: String,
    required: true,
    index: {
      name: 'slug',
      global: true
    }
  }
}

/**
 * Table name, also used for the global instance of the model
 *
 * @constant {string} modelName
 */
const modelName = process.env.DYNAMODB_TABLE_PEOPLE || 'people'

/**
 * Model config, primarily this is to prevent Dynamoose from
 * trying to do anything with regards to managing the table
 * on AWS, since that is all provisioned using terraform.
 *
 * @constant {dynamoose.ModelOption} modelOptions
 */
const modelOptions = {
  create: false,
  update: false,
  waitForActive: {
    enabled: false
  }
}

/**
 * Schema config
 *
 * @see {@link (https://dynamoosejs.com/api/schema/#options)}
 *
 * @constant {object} schemaOptions
 */
const schemaOptions = {
  saveUnknown: true
}

/**
 * Dynamoose model
 */
const schema = new dynamoose.Schema(schemaAttributes, schemaOptions)
const model = dynamoose.model(modelName, schema, modelOptions)

/**
 * See if slug already exists, optinally exclude a specific ID
 *
 * @param {string} slug
 * @param {string} [id]
 */
model.methods.set('slugExists', async function (slug, id = null) {
  const query = this.query('slug').eq(slug)

  if (id) {
    query.and().where('id').not().eq(id)
  }

  const res = await query.count().using('slug').exec()
  return res.count > 0
})

/**
 * Get single Item by its slug
 *
 * @param {string} slug
 */
model.methods.set('getBySlug', async function (slug) {
  const res = await this.query('slug').eq(slug).using('slug').limit(1).exec()
  return res[0]
})

export default model
