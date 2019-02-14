
	<div class="wrapper">
		<h3>Struktura organizacyjna</h3>
		
		<div class="wrapper companystructure">
			
			<canvas id="structure" width="925" height="500" style="border:1px solid #cccccc">
			</canvas>
			
		</div>
	</div>

<script>
			
		var canvas = document.getElementById('structure');
		
		function sq(x,y){
			this.width = 30;
			this.height = 30;
			this.space = 2;
			this.up = function(){
				
			}
		}
		
		var square = {
			width: 30,
			height: 30,
			space: 2,
			getObject: function(x,y) {
				
				var obj = new Object();
				obj.width = this.width;
				obj.height = this.height;
				obj.space = this.space;
				obj.posX = this.width+x;
				obj.posY = this.height+y;
				
				obj.moveDown = function() {
					
				}
				
				return obj;
			}
		};
		
		var block = {
			color : "#ff0000",
			position : "top",
			elements : [ 
				square.getObject(), 
			]
		};
		
		var pattern = new Array(
			( '#ff0000', 'top', new Array(
				{x:0, y:0, w:element.w, h:element.h}, 
				{x:(element.w+element.s), y:0, w:element.w, h:element.h},
				{x:(element.w*2+element.s*2), y:0, w:element.w, h:element.h},
				{x:(element.w*3+element.s*3), y:0, w:element.w, h:element.h}
			) )
		);
		
    	var context = new Array(
			new Array( canvas.getContext('2d'), '#ff0000', { x: 10, y: 10, w: 50, h: 50 } ),
			new Array( canvas.getContext('2d'), '#ff0000', { x: 10, y: 10, w: 50, h: 50 } ),
			new Array( canvas.getContext('2d'), '#ff0000', { x: 10, y: 10, w: 50, h: 50 } ),
			new Array( canvas.getContext('2d'), '#ff0000', { x: 10, y: 10, w: 50, h: 50 } ),
			new Array( canvas.getContext('2d'), '#000000', { x: 10, y: 10, w: 50, h: 50 } ),
			new Array( canvas.getContext('2d'), '#000000', { x: 10, y: 10, w: 50, h: 50 } ),
			new Array( canvas.getContext('2d'), '#000000', { x: 10, y: 10, w: 50, h: 50 } ),
			new Array( canvas.getContext('2d'), '#000000', { x: 10, y: 10, w: 50, h: 50 } ),
			new Array( canvas.getContext('2d'), '#dddddd', { x: 10, y: 10, w: 50, h: 50 } ),
			new Array( canvas.getContext('2d'), '#dddddd', { x: 10, y: 10, w: 50, h: 50 } ),
			new Array( canvas.getContext('2d'), '#dddddd', { x: 10, y: 10, w: 50, h: 50 } ),
			new Array( canvas.getContext('2d'), '#dddddd', { x: 10, y: 10, w: 50, h: 50 } )
		);
		
		var drag = false, dragObj = null, dragPosX, dragPosY;
		
		createContext();
		
		canvas.addEventListener("mousedown", mouseDownListener, false);
		canvas.addEventListener("mouseup", mouseUpListener, false);
		canvas.addEventListener("mousemove", mouseMove, false);
		
	function createContext(){
		
		for(i=0; i<context.length; i++){
			//if(i==0) continue;
			context[i][0].fillStyle = context[i][1];
			context[i][0].fillRect((context[i][2].x+(context[i][2].w*i)+i), (context[i][2].y), context[i][2].w, context[i][2].h);
			context[i][2].x = (context[i][2].x+(context[i][2].w*i)+i);
		}
	}
	
	function mouseDownListener(e) {
		
		var bRect = canvas.getBoundingClientRect();
		var mouse = {
			x: (e.clientX - bRect.left),
			y: (e.clientY - bRect.top)
		};
		
		for (i = context.length-1; i >= 0; i--) {
			
			if(mouse.x >= context[i][2].x && mouse.x <= (context[i][2].x+context[i][2].w) && mouse.y >= context[i][2].y && mouse.y <= (context[i][2].y+context[i][2].h)){
				
				dragPosX = mouse.x-context[i][2].x;
				dragPosY = mouse.y-context[i][2].y;
				
				dragObj = i;
				drag = true;
				
				break;
			}
		}		
		
	}
	
	function mouseUpListener() {
		
		dragPosX = null;
		dragPosY = null;
		dragObj = null;
		drag = false;
	}
	
	function mouseMove(e){
		
		var bRect = canvas.getBoundingClientRect();
		var mouse = {
			x: (e.clientX - bRect.left),
			y: (e.clientY - bRect.top)
		};
		
		if (drag) {
			
			console.log(dragObj);
			context[dragObj][2].x = mouse.x-dragPosX;
			context[dragObj][2].y = mouse.y-dragPosY;
			
			context[dragObj][0].clearRect(0, 0, canvas.width, canvas.height);
			
			for(i=0; i<context.length; i++){
			
				context[i][0].fillStyle = context[i][1];
				context[i][0].fillRect(context[i][2].x, context[i][2].y, context[i][2].w, context[i][2].h);
			}
			
			//dragObj[0].fillRect(mouse.x-dragPosX, mouse.y-dragPosY, 100, 100);			
		}
	}
</script>