
	<div class="wrapper">
		<h3>Struktura organizacyjna</h3>
		
		<div class="wrapper companystructure">
			
			<canvas id="structure" width="925" height="500" style="border:1px solid #cccccc">
			</canvas>
			
		</div>
	</div>

<script>
			
		var canvas = document.getElementById('structure');
		
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
			
			context[i][0].fillStyle = context[i][1];
			context[i][0].fillRect((context[i][2].x+5+(context[i][2].w*i)), context[i][2].y, context[i][2].w, context[i][2].h);
			context[i][2].x = context[i][2].x+5+(context[i][2].w*i);
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