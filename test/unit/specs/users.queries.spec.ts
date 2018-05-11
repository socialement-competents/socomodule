import { GET_USERS, GET_USER_BY_ID } from '@/users/queries'

describe('user queries', () => {
  it('has a getUsers query', () => {
    expect(typeof GET_USERS).toBe('object')
    const operation = GET_USERS.definitions.find((def: any) => def.operation === 'query')
    expect(operation.name.value).toBe('getUsers')
  })

  it('has a getUserById query', () => {
    expect(typeof GET_USER_BY_ID).toBe('object')
    const operation = GET_USER_BY_ID.definitions.find((def: any) => def.operation === 'query')
    expect(operation.name.value).toBe('getUserById')
  })
})
