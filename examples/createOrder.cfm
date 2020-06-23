<cfscript>
	if (structKeyExists(Form, 'apiKey') && structKeyExists(Form, 'email') && structKeyExists(Form, 'return_url')) {
		utrustStores = new models.stores(
				apiKey = encodeForHTML(Form.apiKey)
		);

		orderData = {
			'reference' : 'TEST#createUUID()#',
	    	'amount' : {
	    		'total' : '5.00',
	    		'currency' : 'GBP'
	    	},
	    	'return_urls' : {
				'return_url' : form.return_url,
				'cancel_url' : structKeyExists(form, 'cancel_url') ? form.cancel_url : '',
				'callback_url' : structKeyExists(form, 'callback_url') ? form.callback_url : '',
	    	},
	    	'line_items' : [
	    		{
	            'sku' : 'ACF2018',
	            'name' : 'Adobe ColdFusion 2018',
	            'price' : '2172.00',
	            'currency' : 'GBP',
	            'quantity' : 1,
	        	},
	    		{
	            'sku' : 'Lucee5',
	            'name' : 'Lucee 5',
	            'price' : '0.00',
	            'currency' : 'GBP',
	            'quantity' : 1,
	        	}
	        ]
	    };

		customerData = {
			'first_name' : 'Your',
			'last_name' : 'Name',
			'email' : form.email,
			'country' : 'GB'
		}

		orderResponse = utrustStores.createOrder(
				orderData 		= orderData
			,	customerData 	= customerData
		);

		try {
			location url="#orderResponse.data.attributes.redirect_url#" addtoken="false";
		}
		catch (any e) {
			writeOutput('Error creating order');
			writeDump(orderResponse);
		}
	}
	else {
		location url="/examples/" addtoken="false";
	}
</cfscript>