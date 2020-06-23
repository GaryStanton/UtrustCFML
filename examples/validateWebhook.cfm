<cfscript>
	if (structKeyExists(Form, 'webhookSecret') && structKeyExists(Form, 'payload') && isJSON(Form.payload)) {
		utrustWebhook = new models.webhook(
				webhookSecret = Form.webhookSecret
			,	payload = Form.payload
		);

		// Validate signature - Will throw an error if the signature is invalid. Data is displayed below for reference.
		utrustWebhook.validateSignature();
	}
	else {
		location url="/examples/" addtoken="false";
	}
</cfscript>

<!doctype html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
		<title>Utrust CFML example webhook response</title>
	</head>

	<body>
		<div class="container">
			<h1>Utrust CFML example webhook response</h1>
			<hr>
			<cfoutput>
				<table class="table table-dark">
					<tbody>
						<tr>
							<th>Event type</th>
							<td>#utrustWebhook.getEventType()#</td>
						</tr>
						<tr>
							<th>Order ref</th>
							<td>#utrustWebhook.getOrderReference()#</td>
						</tr>
						<tr>
							<th>State</th>
							<td>#utrustWebhook.getState()#</td>
						</tr>
						<tr>
							<th>Event type</th>
							<td>#utrustWebhook.getEventType()#</td>
						</tr>
						<tr>
							<th>Amount</th>
							<td>#utrustWebhook.getAmount()# #utrustWebhook.getCurrency()#</td>
						</tr>
					</tbody>
				</table>
			</cfoutput>
		</div>
	</body>
</html>
