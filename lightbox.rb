# litebox.rb v.1.0.0
#
#   Options
#     @options['lightbox.url'] = string
#       example:
#         @options['lightbox.url'] = '/lightbox/'
#
#     @options['lightbox.overlayOpacity'] = float
#       controls transparency of shadow overlay
#
#     @options['lightbox.animate'] = boolean
#       toggles resizing animations
#
#     @options['lightbox.resizeSpeed'] = integer
#       controls the speed of the image resizing animations (1=slowest and 10=fastest)
#
#     @options['lightbox.borderSize']  = integer
#       if you adjust the padding in the CSS, you will need to update this variable
#
# Copyright (c) 2007 HASHIMOTO Keisuke <ksk.hashi@gmail.com>
# You can redistribute it and/or modify it under GPL2.

if /(index|update)\.(cgi|rb)$/ =~ $0 then
	@lightbox_url  = @conf['lightbox.url']
	@lightbox_url  = './lightbox/' if @lightbox_url == nil
	@lightbox_url += '/' if %r!/$! !~ @lightbox_url
	
	add_header_proc do
		<<-HTML
			<link rel="stylesheet" href="#{h @lightbox_url}css/lightbox.css" type="text/css" media="screen">
			<script type="text/javascript" src="#{h @lightbox_url}js/prototype.js"></script>
			<script type="text/javascript" src="#{h @lightbox_url}js/scriptaculous.js?load=effects"></script>
			<script type="text/javascript" src="#{h @lightbox_url}js/lightbox.js"></script>
		HTML
	end
	
	add_footer_proc do
		str = <<-END_HTML
			<script type="text/javascript">
			<!--
			(function(){
				var anchors = document.getElementsByTagName( 'a' );
				
				for ( var i = 0; i < anchors.length; i++ ){
					var anchor = anchors[i];
					var rel    = anchor.getAttribute( 'rel' );
					var href   = anchor.getAttribute( 'href' );
					
					if( ( rel == null || rel == '' ) && href && href.match( /\\.(?:jpe?g|gif|png)$/i ) ) {
						rel = 'lightbox';
						
						if( href.match( /\\/(\\d{8})_\\d+\\.\\w+$/i ) ) {
							rel += '[' + RegExp.$1 + ']';
							
							var imgs = anchor.getElementsByTagName( 'img' );
							for( var j = 0; j < imgs.length; ++j ) {
								var title = imgs[j].getAttribute( 'title' );
								
								if( title != null ) {
									anchor.setAttribute( 'title', title );
									break;
								}
							}
						}
						
						anchor.setAttribute( 'rel', rel );
					}
				}
			})();
			
			fileLoadingImage = '#{h @lightbox_url}images/loading.gif';
			fileBottomNavCloseImage = '#{h @lightbox_url}images/closelabel.gif';
		END_HTML
		
		if @conf['lightbox.overlayOpacity'] != nil then
			str += "overlayOpacity = #{h @conf['lightbox.overlayOpacity']};\n"
		end
		
		if @conf['lightbox.animate'] != nil then
			str += "animate = #{if @conf['lightbox.animate'] then 'true' else 'false' end};\n"
		end
		
		if @conf['lightbox.resizeSpeed'] != nil then
			str += "resizeSpeed = #{h @conf['lightbox.resizeSpeed']};\n"
		end
		
		if @conf['lightbox.borderSize'] != nil then
			str += "borderSize = #{h @conf['lightbox.borderSize']};\n"
		end
		
		str + <<-END_HTML
			// -->
			</script>
		END_HTML
	end
end
