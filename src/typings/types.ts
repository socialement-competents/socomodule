/* tslint:disable */

export interface Query {
  users?: (User | null)[] | null;
  userById?: User | null;
}
/** User type */
export interface User {
  _id?: string | null /** The id */;
  email?: string | null /** The email */;
  firstname?: string | null /** The firstname */;
  lastname?: string | null /** The lastname */;
  bio?: string | null /** The bio */;
  image?: string | null /** The image */;
  cards?: (string | null)[] | null /** The cards */;
}

export interface Mutation {
  addUser?: User | null;
}
export interface UsersQueryArgs {
  limit?: number | null /** limit items in the results */;
}
export interface UserByIdQueryArgs {
  id?: string | null /** find by id */;
}
export interface AddUserMutationArgs {
  username: string;
  password: string;
}
