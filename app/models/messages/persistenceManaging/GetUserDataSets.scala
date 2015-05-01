package models.messages.persistenceManaging

/**
 * Created by chetan on 13/04/15.
 */

/**
 * Message to ask the list of available datasets of a user
 * @param username
 */
case class GetUserDataSets(username: String) extends PersistenceMessage

/**
 * Not sure if this is needed, TODO:
 */
case class GetUserResults(username: String) extends PersistenceMessage

