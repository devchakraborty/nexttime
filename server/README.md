# API Calls

## All requests:

- Header: **X-FB-ID**: Facebook ID of user
- Returns 400 with array of error messages if invalid request
- If the request accepts a JSON body, you **must** pass *Content-Type: application/json* in the header.

## POST /login
### Login (/Initial Auth Check)

- Empty request body, empty response body
- Status 200 if successful
- Status 401 if you need to register first

## POST /register
### Initial registration

- Request body: JSON object, fields are:
	- **device_token**: The push notification token of the user
- Status 200 if successful

## GET /reminders
### Get all reminders

- Empty request body
- Response body: JSON **object** of all reminders for the user, indexed by ID

## POST /reminders
### Create reminder

- Request body: JSON object, fields are:
	- **id**: the id of the reminder (UUID)
	- **type**: the type of the reminder ("with" or "near")
	- **specifier**: the target text of the reminder (e.g. "Yale University" or "Dev Chakraborty")
	- **specifier_id**: the id of the specifier (Google Place ID for location, FB ID for friend)
	- **reminder_body**: the body of the reminder (e.g. "buy bread")
- Empty response body
- Status 200 if successful

## POST /reminders/:id
### Update reminder

- Request body: JSON object, same fields as POST /reminders
- Empty response body

## DELETE /reminders/:id
### Delete reminder

- Empty request body
- Empty response body
- Status 200 if successful

## POST /location
### Update own location

- Request body: JSON object, fields are:
	- **lat**: latitude of the user
	- **lng**: longitude of the user
- Empty response body
- Status 200 if successful
