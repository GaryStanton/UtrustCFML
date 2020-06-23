<!doctype html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
		<title>Utrust CFML examples</title>
	</head>

	<body>
		<div class="container">
			<h1>Utrust CFML examples</h1>
			<hr>

			<div class="row">
				<div class="col-sm-6">
					<div class="mr-4">
						<h2>Create order</h2>
						<form action="createOrder.cfm" method="POST">
							<div class="form-group">
								<label for="apiKey">API Key</label>
								<input type="text" required="true" class="form-control" id="apiKey" name="apiKey" aria-describedby="apiKey" placeholder="Enter sandbox API key">
								<small id="apiKeyHelp" class="form-text text-muted">You can obtain a sandbox API key from the <a href="https://merchants.sandbox-utrust.com/onboarding/get-started">Utrust website</a></small>
							</div>

							<div class="form-group">
								<label for="email">Email address</label>
								<input type="text" required="true" class="form-control" id="email" name="email" aria-describedby="email" placeholder="your@email">
							</div>

							<br />

							<div class="form-group">
								<label for="return_url">Return URLs</label>
								<input type="text" required="true" class="form-control" id="return_url" name="return_url" aria-describedby="return_url" placeholder="http://example.com/success">
								<input type="text" class="form-control" id="cancel_url" name="cancel_url" aria-describedby="cancel_url" placeholder="http://example.com/cancelled">
								<input type="text" class="form-control" id="callback_url" name="callback_url" aria-describedby="callback_url" placeholder="http://example.com/callback">
								<small id="urlHelp" class="form-text text-muted">
									You must provide a return URL for a successful transaction. Other URLs are optional.
									<br /><span class="text-info">Please note: The API does not accept addresses with port numbers.</span>
								</small>
							</div>
							<button type="submit" class="btn btn-primary">Create test order</button>
						</form>
					</div>
				</div>

				<div class="col-sm-6">
					<div class="ml-4">
						<h2>Validate webhook</h2>
						<form action="validateWebhook.cfm" method="POST">
							<div class="form-group">
								<label for="apiKey">Webhook secret</label>
								<input type="text" required="true" class="form-control" id="webhookSecret" name="webhookSecret" aria-describedby="webhookSecret" placeholder="Enter webhook secret">
								<small id="apiKeyHelp" class="form-text text-muted">You can obtain a sandbox webhook secret key from the <a href="https://merchants.sandbox-utrust.com/onboarding/get-started">Utrust website</a></small>
							</div>

							<div class="form-group">
								<label for="payload">Payload</label>
								<textarea class="form-control" id="payload" name="payload" aria-describedby="payload" rows="5" placeholder="Enter callback payload JSON"></textarea>
								<small id="payloadHelp" class="form-text text-muted">
									To obtain a webhook payload, you can specify a 'RequestBin' style URL in the callback field when creating an order in the previous form.
									<br />
									The response is contained in the request body, but for testing purposes you can simply paste it here to check the data is valid.
								</small>
							</div>

							<button type="submit" class="btn btn-primary">Submit callback payload</button>
						</form>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>