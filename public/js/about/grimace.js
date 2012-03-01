// portions courtesy of http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/external/ExternalInterface.html
var grimace;

var jsReady = false;
function isReady() {
	return jsReady;
}


function getMovie(movieName) {
	if (navigator.appName.indexOf("Microsoft") != -1) {
		return window[movieName];
	}
	else {
		return document[movieName];
	}
}


function initListeners() {
	try {
		if (!grimace.isReady()) {
			throw new Error('Grimace not ready');
		}
		grimace.addEventListener('loadComplete', 'onLoadComplete');
		grimace.addEventListener('captureComplete', 'onCaptureComplete');
	}
	catch (e) {
		// Retry later if Grimace was not ready yet.
		setTimeout(initListeners, 300);
	}
}



function loadFacedata() {
	var ok;
	try {
		if (!grimace.isReady()) {
			throw new Error('Grimace not ready');
		}
		
		// Paths are relative to location of Grimace.swf
		grimace.loadFacedata(new Array(
			'head.xml',
			'features.xml',
			'wrinkles.xml',
			'emotions.xml',
			'overlays.xml'
		), 'flash/grimace/meta/');
		
		grimace.setCaptureUrl('../../../SaveFile.php');
	}
	catch (e) {
		// Retry later if Grimace was not ready yet.
		setTimeout(loadFacedata, 300);
	}
}

function onLoadComplete() {
	document.getElementById('grimace_wheel').style.backgroundImage = 'none';
	grimace.setPosition(0,0);
	grimace.setScaleMode("showAll");
	grimace.draw();
}

function onCaptureComplete(e) {
	document.getElementById('captures').innerHTML += "<li><img src='"+e.url+"'/></li>";
}



// emotion sliders based on jquery ui
var sliders = {
	resolution: 100,
	
	values: {
		joy:      0,
		surprise: 0,
		fear:     0,
		sadness:  0,
		disgust:  0,
		anger:    0
	},
	
	init: function() {
		var scope = this;
		
		$('#joy').slider({
			max: this.resolution,
			slide: function(e,ui){
				scope.slide('joy');
			}
		});
		$("#surprise").slider({
			max: this.resolution,
			slide: function(e,ui){
				scope.slide('surprise');
			}
		});
		$("#fear").slider({
			max: this.resolution,
			slide: function(e,ui){
				scope.slide('fear');
			}
		});
		$("#sadness").slider({
			max: this.resolution,
			slide: function(e,ui){
				scope.slide('sadness');
			}
		});
		$("#disgust").slider({
			max: this.resolution,
			slide: function(e,ui){
				scope.slide('disgust');
			}
		});
		$("#anger").slider({
			max: this.resolution,
			slide: function(e,ui){
				scope.slide('anger');
			}
		});
	},
	
	notify: true,
	
	slide: function(emotion) {
		if (!this.notify) {
			return;
		}
		
		var value = $('#'+emotion).slider('value');
		value /= this.resolution;

		this.values[emotion] = value;
		
		
		this.update();
		
		// Immediately set new emotion
		grimace.setEmotion(this.values, 0);
	},
	
	update: function() {
		// Deactivate unused sliders when two emotions are already active.
		// Mixtures of more than 3 emotions are possible,
		// but usually unintelligible.
		
		var active = 0;
		console.log(this.values)
		for (var i in this.values) {
			if (this.values[i] > 0) {
				active++;
			}
		}
		
		if (active >= 2) {
			for (var i in this.values) {
				if (this.values[i] == 0) {
					$('#'+i).slider('disable');
				}
				else {
					$('#'+i).slider('enable');
				}
			}
		}
		else {
			for (var i in this.values) {
				$('#'+i).slider('enable');
			}
		}
	}
}

function onEmotionSet() {
	grimace.removeEventListener('emotionSet', 'onEmotionSet');
	
	sliders.notify = false;
	
	var emotions = grimace.getEmotion()
	for (var i in sliders.values) {
		if (emotions[i]) {
			sliders.values[i] = emotions[i];
		}
		else {
			sliders.values[i] = 0;
		}
	}
	for (var i in sliders.values) {
		$('#'+i).slider('moveTo', 100 * sliders.values[i]);
	}
	
	sliders.update();
	sliders.notify = true;
}


// Add button functionality

function initButtons() {
	var restart = document.getElementById('restart');
	restart.onclick = function() {
		grimace.restart();
		loadFacedata();
	}
	if (restart.captureEvents) restart.captureEvents(Event.CLICK);


	var reset = document.getElementById('reset');
	reset.onclick = function() {
		grimace.addEventListener('emotionSet', 'onEmotionSet');
		grimace.resetEmotion(0.3);
	}
	if (reset.captureEvents) reset.captureEvents(Event.CLICK);

}

/*	
	var draw = document.getElementById('draw');
	draw.onclick = function() {
		grimace.draw();
	}
	if (draw.captureEvents) draw.captureEvents(Event.CLICK);

	var setPos = document.getElementById('setPos');
	setPos.onclick = function() {
		var posX = document.getElementById('posX').value;
		var posY = document.getElementById('posY').value;
		grimace.setPosition(posX, posY);
	}
	if (setPos.captureEvents) setPos.captureEvents(Event.CLICK);

	var getPos = document.getElementById('getPos');
	getPos.onclick = function() {
		var pos = grimace.getPosition();
		var out = 'x: ' + pos.x + '<br/>y: ' + pos.y;
		log(out);
	}
	if (setPos.captureEvents) setPos.captureEvents(Event.CLICK);

	var resize = document.getElementById('resize');
	resize.onclick = function() {
		var width = document.getElementById('width').value;
		var height = document.getElementById('height').value;
		grimace.setMaxBounds(width, height);
	}
	if (resize.captureEvents) resize.captureEvents(Event.CLICK);

	var getBounds = document.getElementById('getBounds');
	getBounds.onclick = function() {
		var bounds = grimace.getMaxBounds();
		var out = 'width: ' + bounds.width + '<br/>height: ' + bounds.height;
		log(out);
	}
	if (getBounds.captureEvents) getBounds.captureEvents(Event.CLICK);

	var set1 = document.getElementById('set1');
	set1.onclick = function() {
		grimace.addEventListener('emotionSet', 'onEmotionSet');
		grimace.setEmotion({anger:1.0, surprise:0.5}, 0.3);
	}
	if (set1.captureEvents) set1.captureEvents(Event.CLICK);

	var set2 = document.getElementById('set2');
	set2.onclick = function() {
		grimace.addEventListener('emotionSet', 'onEmotionSet');
		grimace.setEmotion({joy:1.0, disgust:0.5}, 0.3);
	}
	if (set2.captureEvents) set2.captureEvents(Event.CLICK);

	var reset = document.getElementById('reset');
	reset.onclick = function() {
		grimace.addEventListener('emotionSet', 'onEmotionSet');
		grimace.resetEmotion(0.3);
	}
	if (reset.captureEvents) reset.captureEvents(Event.CLICK);


	var getEmotion = document.getElementById('getEmotion');
	getEmotion.onclick = function() {
		var out = '';
		var emotion = grimace.getEmotion();
		for (var i in emotion) {
			out += i+": "+emotion[i]+"<br/>";
		}
		if (!out) {
			out = "neutral";
		}
		log(out);
	}
	if (getEmotion.captureEvents) getEmotion.captureEvents(Event.CLICK);

	var capture = document.getElementById('capture');
	capture.onclick = function() {
		grimace.capture();
	}
	if (capture.captureEvents) capture.captureEvents(Event.CLICK);
	
	var showAll = document.getElementById('showAll');
	showAll.onclick = function() {
		grimace.setScaleMode('showAll');
		document.getElementById('sizeOptions').style.display = 'none';
		grimace.setMaxBounds(0,0);
	}
	if (showAll.captureEvents) showAll.captureEvents(Event.CLICK);
	
	var noScale = document.getElementById('noScale');
	noScale.onclick = function() {
		grimace.setScaleMode('noScale');
		document.getElementById('sizeOptions').style.display = 'block';
	}
	if (noScale.captureEvents) noScale.captureEvents(Event.CLICK);
	
}

function log(msg) {
	document.getElementById('log').innerHTML = msg;
}*/


jsReady = true;
grimace = getMovie('Grimace');

sliders.init();

initListeners();

// initButtons();

if (document.location.toString().indexOf('file://') != -1) {
 	alert('Because of Flash security restrictions, this demo must be served by a web server and accessed by http://. You cannot use the demo from a file:// context.');
}
else {
	loadFacedata();
}

