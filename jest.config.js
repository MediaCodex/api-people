const targetCoverage = 0

module.exports = {
  clearMocks: true,
  coveragePathIgnorePatterns: [
    'test',
    'lib'
  ],
  coverageThreshold: {
    global: {
      branches: targetCoverage,
      functions: targetCoverage,
      lines: targetCoverage
    }
  },
  testEnvironment: 'node',
  testMatch: [
    '**/test/**/*.js'
  ],
  testPathIgnorePatterns: [
    'jest-helpers.js'
  ],
  transform: {
    '^.+\\.[t|j]sx?$': 'esm'
  }
}
