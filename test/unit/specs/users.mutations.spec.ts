import { REGISTER } from '@/users/mutations'

describe('user mutations', () => {
  it('has a register mutation', () => {
    expect(typeof REGISTER).toBe('object')
    const operation = REGISTER.definitions.find((def: any) => def.operation === 'mutation')
    expect(operation.name.value).toBe('register')
  })
})
