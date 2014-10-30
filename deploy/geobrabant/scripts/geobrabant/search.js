(function(GeoBrabant) {
    "use strict";
    GeoBrabant.SearchComponent = {
        config: {},
        resultContainer: null,
        defaultContent: '',
        init: function(conf) {
            var me = this;
            this.config = $.extend({}, {
                container: '.zoekresultaten',
                searchString: '',
                searchType: '',
                searchUrl: '',
                resultUrl: '',
                contextPath: '',
                searchKey: 'searchString',
                resultClass: 'zoekresultaat',
                summaryLength: 0,
                resultCallback: null
            }, conf);
            this.resultContainer = $(this.config.container);
            this.defaultContent = this.resultContainer.html();
            if(this.config.searchString !== '') {
                this.search(this.config.searchString, this.config.searchType);
            }
            return me;
        },
        search: function(searchString, searchType) {
            var me = this;
            this.config.searchString = this.prepareSearchString(searchString);
            console.log(this.config.searchString);
            if(this.config.searchString === '') {
                this.resultContainer.html(this.defaultContent);
                return;
            }
            this.config.searchType = searchType;
            this.showLoadingSpinner();
            var searchData = {
                'searchType': this.config.searchType,
                'resultType': 'json'
            };
            searchData[this.config.searchKey] = this.config.searchString;
            $.ajax(this.config.searchUrl, {
                data: searchData,
                dataType: 'json',
                type: 'POST',
                success: function(result) {
                    me.resultContainer.empty();
                    if(result.result && result.result.length > 0) {
                        for(var i = 0; i < result.result.length; i++) {
                            me.createSearchResult(result.result[i]);
                        }
                        if(me.config.resultCallback !== null && me.config.resultCallback instanceof Function) {
                            me.config.resultCallback(result);
                        }
                    } else {
                        me.resultContainer.text('Geen resultaten gevonden');
                    }
                },
                error: function(jqXHR) {
                    me.resultContainer.html($("<div/>", {
                        "class": "message_err",
                        html: jqXHR.responseText
                    }));
                }
            });
        },
        createSearchResult: function(searchResult) {
            var header = $('<h2></h2>');
            if(this.config.resultUrl) {
                header.append($('<a></a>').text('Meer info').attr({
                    'href': this.config.resultUrl + searchResult.uuid
                }));
            }
            header.append($('<span></span>').text(searchResult.title));
            var abstract = searchResult.abstractString;
            if(this.config.summaryLength !== 0) {
                abstract.length > this.config.summaryLength && (abstract = abstract.substring(0, this.config.summaryLength) + '...');
            }
            this.resultContainer.append(
                $('<div></div>')
                .addClass(this.config.resultClass)
                .append(header)
                .append($('<p></p>').text(abstract))
            );
        },
        prepareSearchString: function(searchString) {
            return searchString.trim();
        },
        showLoadingSpinner: function() {
            this.resultContainer.html($("<img />", {
                src: this.config.contextPath + "/styles/images/spinner.gif"
            }));
        }
    };
}(window.GeoBrabant = window.GeoBrabant || {}));