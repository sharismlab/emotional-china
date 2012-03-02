
//some global variable 
var selected ; //for selected item
var NUM_PARTICLES = 40;
var w = window.innerWidth-30;

// Ball contructor
            function Ball(x, y, vx, vy, color, label, linkText){
                this.x = x;
                this.y = y;
                this.vx = vx;
                this.vy = vy;
                this.color = color;
                this.origX = x;
                this.origY = y;
                this.radius = 10;
                this.label = label;
                this.linkText = linkText;
}

// store data in an array
function initBalls(){
                balls = [];
                outBalls = []
                var VELOCITY = 1;
                var colors = [ "#02A817","#3A5BCD", "#FFC636", "#FF0000","#FFFF00" ];

var space = w/6; 

                // start with some balls
                balls.push(new Ball(space, 50+Math.random()*10, 0, 0, '#000000', 'Robot', '#one'));
                balls.push(new Ball(2*space, 50+Math.random()*10, 0, 0, '#000000', 'Feeling', '#two'));
                balls.push(new Ball(3*space, 50+Math.random()*10, 0, 0, '#000000', 'Math', '#three'));
                balls.push(new Ball(4*space, 50+Math.random()*10, 0, 0, '#000000', 'Brain', '#four'));
                balls.push(new Ball(5*space, 50+Math.random()*10, 0, 0, '#000000', 'Contact', '#five'));

                  for (var n = 0; n < NUM_PARTICLES; n++) {
                    var posNeg = (Math.random() < 0.5 ? -1 : 1);
                    var outX = posNeg*100*Math.random(); 
                    var outY =  posNeg*100*Math.random();
                    var outRadius = 10*Math.random();
                    var vx = ((Math.random()*(VELOCITY*2))-VELOCITY);
                    var vy =  ((Math.random()*(VELOCITY*2))-VELOCITY);
                    var color = colors[ Math.floor( Math.random() * colors.length ) ];
                    var outBall = new Ball(outX, outY, vx, vy, color,4);
                    outBall.radius = outRadius;  
                    outBalls.push(outBall);
                    } // end n

                return balls;
}

// get mouse coordonates

    function getMousePos(canvas, evt){
        // get canvas position
        var obj = canvas;
        var top = 0;
        var left = 0;
        while (obj.tagName != 'BODY') {
            top += obj.offsetTop;
            left += obj.offsetLeft;
            obj = obj.offsetParent;
        }
        
        // return relative mouse position
        var mouseX = evt.clientX - left + window.pageXOffset;
        var mouseY = evt.clientY - top + window.pageYOffset;
        return {
            x: mouseX,
            y: mouseY
        };
    }

function buildBall(curveLayer, ballsLayer, textLayer, ball){

            var myBall = new Kinetic.Circle({
                  x:  ball.x,
                  y : ball.y,
                  radius : ball.radius,
                  stroke: "#666",
                  fill: ball.color,
                  strokeWidth: 2,
                  draggable: true,
                  linkText : ball.linkText
            });

            // set curve points on dragmove
            myBall.on("dragmove", function(){
                drawCurves(curveLayer);
                this.label.x = this.x-5;
                this.label.y = this.y+12;
                
                textLayer.draw();
            });

            myBall.on("mousedown", function(){
                selected = this;
                
                console.log(this.linkText)
                //window.location = this.linkText;
                
                $('#slider').scrollTo(this.linkText, 800);
                
                return false;
            });

            // add hover styling
            myBall.on("mouseover", function(){
                document.body.style.cursor = "pointer";
                this.setStrokeWidth(4);
                this.setScale(2.5);
                this.setAlpha(0.7);
                ballsLayer.draw();
                
            });

            myBall.on("mouseout", function(){
                document.body.style.cursor = "default";
                this.setStrokeWidth(2);
                this.setScale(1);
                ballsLayer.draw();
            });

            ballsLayer.add(myBall);
            var myLabel = buildLabel(ball,textLayer);
            myBall.label = myLabel;
            textLayer.add(myLabel);
            return myBall; 
}

function buildLabel(ball,textLayer) {

	var lx = ball.x-5;
	var ly = ball.y +12;
	    var label = new Kinetic.Shape({
              drawFunc: function(){
		var context = this.getContext();
		context.beginPath();
		context.moveTo(lx,ly);
		context.fillStyle = "rgba(0,0,0,.5)";
		context.fillRect(0, 0, 50, 25);
		context.font = "12pt Calibri";
		context.fillStyle = "white";
		context.textBaseline = "top";
		context.fillText(ball.label, 4, 4);
	      }
	    });
	    label.x = lx;
	    label.y = ly;
	    textLayer.add(label);
            return label;

}

function buildParticles(particlesLayer) {
    for (var m = 0; m < NUM_PARTICLES; m++) { 
                
                    var outBall = outBalls[m];
                    
                    var myOutBall = new Kinetic.Circle({
		          x:  outBall.x,
		          y : outBall.y,
		          radius : outBall.radius,
		          radiusSq : outBall.radius*outBall.radius,
		          stroke: outBall.color,
		          fill: 'transparent',
		          strokeWidth: 0,
		          draggable: true,
		          vx: outBall.vx,
		          vy:outBall.vy,
		          ox : outBall.x,
			  oy : outBall.y,
			  fx : 0,
			  fy : 0,
		          mass : 0.01 + Math.random() * 0.99,
		          fixed : false
            		});
            		
                    particlesLayer.add(myOutBall); // add ball to Layer
                    
       } // end for n particles
}

function drawCurves(curveLayer){
            var context = curveLayer.getContext();
            curveLayer.clear();

            // draw bezier
            var bezier = curveLayer.bezier;
            
             // draw curve
            context.beginPath();
            context.moveTo(curveLayer.bezier[0].x, curveLayer.bezier[0].y);
            
            for(var i=1; i < curveLayer.bezier.length; i++) {
                context.lineTo(curveLayer.bezier[i].x, curveLayer.bezier[i].y);
            }
            
            context.strokeStyle = "#ccc";
            context.lineWidth = 2;
            context.stroke();
            context.closePath();

}


// update Balls
function updateBalls(balls,mousePos){
          var G = 9.81; // gravitation
          var ballLayer = balls[0].getLayer();
          var stage = balls[0].getStage();
          var canvas = ballLayer.getContext();
          var restoreForce = 0.02;
          var collisionDamper = 0.3;

          // mp is the main object, center of gravitation
          var mp = balls[0];
          //selection style
          mp.setScale(1.5);
          mp.fill = "transparent";
          mp.stroke = "#ccc";
          mp.radius = 10;
          mp.mass = 60.0;
          mp.fixed = true;
          mp.x = mp.ox = mousePos.x;
          mp.y = mp.oy = mousePos.y;
          
          var p1, p2, f, dx, dy, dSq;
              
          for (var n = 0; n < NUM_PARTICLES; n++) {
            var outBall = balls[n];
            var p1 = outBall;
            
             for(var j = n; j < NUM_PARTICLES; j++) {
                  p2 = balls[j];
                  
                   dx = p2.x - p1.x;
                   dy = p2.y - p1.y;
                   dSq = dx*dx + dy*dy;

		    // Compute force
		    f = (G * p1.mass * p2.mass) / dSq;
		    
		    if(dSq > p1.radiusSq + p2.radiusSq) {
		        
		        p1.fx += dx * f;
		        p1.fy += dy * f;
		        
		        p2.fx += dx * -f;
		        p2.fy += dy * -f;
		        
		    } else if(dSq > 0.001) {
		        
		        p1.fx += dx * -f;
		        p1.fy += dy * -f;
		        
		        p2.fx += dx * f;
		        p2.fy += dy * f;
		    }
		     
		} // end foreach j p2
		
               // create canvas box to contain particles
                  // Set floor condition
                    if (outBall.y > (canvas.height - outBall.radius)) {
                        outBall.y = canvas.height - outBall.radius - 2;
                        outBall.vy *= -1;
                        outBall.vy *= (1 - collisionDamper);
                    }
                    
                    // ceiling condition
                    if (outBall.y < (outBall.radius)) {
                        outBall.y = outBall.radius + 2;
                        outBall.vy *= -1;
                        outBall.vy *= (1 - collisionDamper);
                    }
                    
                    // right wall condition
                    if (outBall.x > (canvas.width - outBall.radius)) {
                        outBall.x = canvas.width - outBall.radius - 2;
                        outBall.vx *= -1;
                        outBall.vx *= (1 - collisionDamper);
                    }
                    
                    // left wall condition
                    if (outBall.x < (outBall.radius)) {
                        outBall.x = outBall.radius + 2;
                        outBall.vx *= -1;
                        outBall.vx *= (1 - collisionDamper);
                    }
       } // end for p1 loop


// Integrate logic
    for(var i = 0; i < NUM_PARTICLES; i++) {
        
        p1 = balls[i];
        
        if(!p1.fixed) {
            
            p1.fx /= NUM_PARTICLES;
            p1.fy /= NUM_PARTICLES;
            
            p1.fx /= p1.mass;
            p1.fy /= p1.mass;
            
            // Integrate
            p1.vx += p1.fx;
            p1.vy += p1.fy;
            
            p1.ox = p1.x;
            p1.oy = p1.y;
            
            p1.x += p1.vx;
            p1.y += p1.vy;
            
            p1.vx *= 0.995;
            p1.vy *= 0.995;
        }
        
        p1.fx = 0;
        p1.fy = 0;
    }
}

function animate(balls, layer, mousePos){
        var ballsLayer = layer ;

        // update balls
        updateBalls(balls,mousePos);
	
        // draw
        ballsLayer.draw();
       }


// start rendering 
        window.onload = function(){
               var stage = new Kinetic.Stage("particle", w, 150);
               var curveLayer = new Kinetic.Layer();
               var ballsLayer = new Kinetic.Layer();
               var particlesLayer = new Kinetic.Layer();
               var textLayer = new Kinetic.Layer();
               
           // draw balls and curves
           var balls = initBalls();
           curveLayer.bezier = [];

           for(z=0;z<balls.length;z++) {
             curveLayer.bezier.push( buildBall(curveLayer, ballsLayer, textLayer, balls[z]) );
           }

           buildParticles(particlesLayer);

           stage.add(curveLayer);
           stage.add(ballsLayer);
           stage.add(particlesLayer);
           stage.add(textLayer);
           
           drawCurves(curveLayer);
           
           var outBalls =  particlesLayer.children;

                // get Mouse Position (useless here !)
                var mousePos = {
                    x: 9999,
                    y: 9999
                };
                
                var canvas = particlesLayer.getCanvas()
                
                canvas.addEventListener("mousemove", function(evt){
                    var pos = getMousePos(canvas, evt);
                    mousePos.x = pos.x;
                    mousePos.y = pos.y;
                });
                
                canvas.addEventListener("mouseout", function(evt){
                    mousePos.x = 9999;
                    mousePos.y = 9999;
                });

	// select first ball by default 
           if(!selected) {
             selected = ballsLayer.children[0];
           }


           // start animation
           stage.onFrame(function(frame){
                animate(outBalls, particlesLayer, selected);
            });
 
            stage.start();

        };



