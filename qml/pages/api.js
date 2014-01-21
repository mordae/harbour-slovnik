/*
 * Look up translation of given word using <http://slovnik.cz/>.
 *
 * @param dict  Dictionary to use for the lookup, usually something similar
 *              to 'encz.cz'.  The second part (after the dot) represents
 *              source language, that is the language of the word.
 *
 * @param word  The word to look up.  Can be a short phrase as well.
 *              Any whitespace characters will be reduced to a single space.
 *
 * @param count Number of results to return.
 *
 * @returns Object with the pending translation request that can be
 *          cancelled or reacted upon it's success or failure.
 */
function Translate(dict, word, count)
{
	dict = dict   || 'encz.cz';
	word = word   || 'a';
	count = count || 30;

	var self = this;

	self.req = new XMLHttpRequest();

	self.onerror = function() {};
	self.ondata = function() {};

	this.abort = function() {
		return self.req.abort();
	};

	this.send = function() {
		self.req.send();
	};

	function parse(data)
	{
		data = data.replace(/[\r\n]/g, ' ');
		data = data.replace(/.*<div id="vocables_main">/, '');
		data = data.replace(/<div id="seek">.*/, '');
		data = data.trim();
		data = data.split(/<div class="pair">/);

		data.shift();
		data.shift();

		var results = [];

		for (var i = 0; i < data.length; i++) {
			var items = data[i].split(/<\/span> - <span [^>]*>/);
			var from = items[0].replace(/<\/?[^>]*>/g, '').trim();
			var to   = items[1].replace(/<\/?[^>]*>/g, '').trim();
			results.push({from: from, to: to});
		}

		return results;
	}

	self.req.onreadystatechange = function() {
		if (XMLHttpRequest.DONE != self.req.readyState)
			return;

		if (200 != self.req.status)
			return self.onerror(self.req.responseText);

		return self.ondata(parse(self.req.responseText));
	};

	self.req.onerror = function() {
		return self.onerror('network error');
	};

	self.req.open('GET', 'http://slovnik.cz/bin/mld.fpl'
				+ '?vcb=' + escape(word)
				+ '&dictdir=' + escape(dict)
				+ '&lines=' + escape(count)
				+ '&js=1');
	self.req.responseType = 'text';
	return self;
}
