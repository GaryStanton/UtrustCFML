/**
* This module wraps the Utrust API: https://utrust.com/
**/
component {

	// Module Properties
    this.modelNamespace			= 'utrustCFML';
    this.cfmapping				= 'utrustCFML';
    this.parseParentSettings 	= true;

	/**
	 * Configure
	 */
	function configure(){

		// Skip information vars if the box.json file has been removed
		if( fileExists( modulePath & '/box.json' ) ){
			// Read in our box.json file for so we don't duplicate the information above
			var moduleInfo = deserializeJSON( fileRead( modulePath & '/box.json' ) );

			this.title 				= moduleInfo.name;
			this.author 			= moduleInfo.author;
			this.webURL 			= moduleInfo.homepage;
			this.description 		= moduleInfo.shortDescription;
			this.version			= moduleInfo.version;

		}

		// Settings
		settings = {
				'apiKey' : ''
			,	'webhookSecret' : ''
			,	'environment' : 'sandbox'
		};
	}

	function onLoad(){
		binder.map( "stores@utrustCFML" )
			.to( "#moduleMapping#.models.stores" )
			.asSingleton()
			.initWith(
					apiKey 		= settings.apiKey
				,	environment = settings.environment
			);

		binder.map( "webhook@utrustCFML" )
			.to( "#moduleMapping#.models.webhook" )
			.initWith(
					webhookSecret = settings.webhookSecret
			);
	}

}