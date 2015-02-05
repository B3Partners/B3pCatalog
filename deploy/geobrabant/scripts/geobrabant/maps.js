(function(GeoBrabant) {
    "use strict";
    GeoBrabant.Maps = {

        buttonContainer: null,
        buttons: [],
        content: null,
        iframe: null,
        activeButton: null,

        init: function() {
            var me = this;
            this.buttonContainer = document.querySelector('.buttons');
            this.buttons = this.buttonContainer.querySelectorAll('.button');
            this.content = document.querySelector('.content');
            this.iframe = this.content.querySelector('iframe');
            this.maximizeIframeHeight();
            this.handleButtonClick({ target: this.buttons.length ? this.buttons[0] : null });
            this.setListeners();
        },

        setListeners: function() {
            var me = this;
            window.addEventListener('resize', function() {
                me.maximizeIframeHeight();
            }, true);
            for(var i = 0; i < this.buttons.length; i++) {
                this.buttons[i].addEventListener('click', function(e) {
                    me.handleButtonClick(e);
                }, true);
            }
        },

        maximizeIframeHeight: function() {
            var totalHeight = this.buttonContainer.offsetHeight,
                windowHeight = window.innerHeight - document.querySelector('header').offsetHeight - document.querySelector('footer').offsetHeight - 20; // minus padding
            this.content.style.height = (windowHeight > totalHeight ? windowHeight : totalHeight) + 'px';
        },

        handleButtonClick: function(e) {
            var button = e.target;
            if(button.tagName.toLowerCase() === 'span') {
                button = button.parentNode;
            }
            if(button) {
                if(this.activeButton) {
                    this.activeButton.className = this.activeButton.className.replace(' active', '');
                }
                this.iframe.src = this.createUrl(button.getAttribute('data-url'), this.getMapExtent());
                button.className += ' active';
                this.activeButton = button;
            }
        },
		
		getMapExtent: function() {
			try {
				return this.iframe.contentWindow.viewerController.mapComponent.getMap().getExtent();
			} catch(e) {
				return null;
			}
		},
		
		createUrl: function(url, extent) {
			if(extent !== null) {
				var index = url.indexOf("?");
				url += (index > 0 ? '&' : '?');
				url += 'extent=';
                url += extent.minx+","+extent.miny+","+extent.maxx+","+extent.maxy;
			}
			return url;
		}

    };
    GeoBrabant.Maps.init();
}(window.GeoBrabant = window.GeoBrabant || {}));