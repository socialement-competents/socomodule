import gql from 'graphql-tag'

export const REGISTER = gql`
mutation register($username: String!, $password: String!) {
  addUser(username: $username, password: $password) {
    id,
    email,
    firstname,
    lastname,
    bio,
    image
  }
}
`
