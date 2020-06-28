# Utrust CFML

Utrust CFML provides a wrapper for the Utrust crypto payments API.  
Obtain an API key from https://utrust.com/.  
Check out the Utrust API documentation here: https://docs.api.utrust.com/.

## Installation
```js
box install utrustcfml
```

## Examples
Check out the `/examples` folder for an example order and response.

## Usage
The Utrust CFML wrapper consists of two models. 
The `stores` model is a singleton, used to create your order. 
The `webhook` model is a transient used to process the payload returned by the Utrust order callback.

The wrapper may be used standalone, or as a ColdBox module.

### Standalone
```cfc
utrustStores = new models.stores(
	apiKey = 'UTRUST_KEY'
);
```

### ColdBox
```cfc
utrust = getInstance("stores@UtrustCFML");
```
alternatively inject it directly into your handler
```cfc
property name="utrust" inject="stores@UtrustCFML";
```

When using with ColdBox, you'll want to insert your API key into your module settings:

```cfc
utrustCFML = {
		apiKey = getSystemSetting("UTRUST_KEY", "")
	,	webhookSecret = getSystemSetting("UTRUST_WEBHOOK", "")
	,	environment = 'sandbox'
}
```


### Create an order
To create an order, send your order JSON to the `createOrder` function and redirect to the URL provided by the API.
More details are available at the Utrust API documention.

```cfc
orderData = {
	'reference' : 'Order_#createUUID()#',
	'amount' : {
		'total' : '2172.00',
		'currency' : 'GBP'
	},
	'return_urls' : {
		'return_url' : 'https://example.com/payment_successful.cfm',
		'cancel_url' : 'https://example.com/payment_cancelled.cfm',
		'callback_url' : 'https://example.com/payment_callback.cfm'
	},
	'line_items' : [
		{
			'sku' : 'ACF2018',
			'name' : 'Adobe ColdFusion 2018',
			'price' : '2172.00',
			'currency' : 'GBP',
			'quantity' : 1
		}
	]
};

customerData = {
	'first_name' : 'Your',
	'last_name' : 'Name',
	'email' : 'your@email.com',
	'country' : 'GB'
}

orderResponse = utrust.createOrder(
		orderData 	= orderData
	,	customerData 	= customerData
);

try {
	location url="#orderResponse.data.attributes.redirect_url#" addtoken="false";
}
catch (any e) {
	writeOutput('Error creating order');
	writeDump(orderResponse);
}
```


### Handle the callback payload
Crypto payments take a while to be confirmed on the blockchain. 
Once complete, Utrust will send confirmation to your callback URL.
You can use the webhook object to confirm the signature and read the data.

```cfc
utrustWebhook = new models.webhook(
		webhookSecret 	= 'WEBHOOK_SECRET'
	,	payload 	= ToString(getHTTPRequestData().content)
);
```

Or using ColdBox:
```cfc
utrustWebhook = getInstance(name='webhook@utrustCFML', initArguments={payload = ToString(getHTTPRequestData().content)});
```

Validate signature - Will throw an error if the signature is invalid.
```cfc
utrustWebhook.validateSignature();
```

## Author
Written by Gary Stanton.  
https://garystanton.co.uk
