
//${CONFIG_BEGIN}
CFG_BINARY_FILES="*.bin|*.dat";
CFG_BRL_DATABUFFER_IMPLEMENTED="1";
CFG_BRL_GAMETARGET_IMPLEMENTED="1";
CFG_BRL_STREAM_IMPLEMENTED="1";
CFG_BRL_THREAD_IMPLEMENTED="1";
CFG_CD="";
CFG_CONFIG="release";
CFG_GLFW_WINDOW_HEIGHT="600";
CFG_GLFW_WINDOW_RESIZABLE="1";
CFG_GLFW_WINDOW_SAMPLES="2";
CFG_GLFW_WINDOW_TITLE="Vortex2 Robot";
CFG_GLFW_WINDOW_WIDTH="800";
CFG_HOST="winnt";
CFG_HTML5_WEBAUDIO_ENABLED="1";
CFG_IMAGE_FILES="*.png|*.jpg";
CFG_LANG="js";
CFG_MODPATH="";
CFG_MOJO_AUTO_SUSPEND_ENABLED="1";
CFG_MOJO_DRIVER_IMPLEMENTED="1";
CFG_MUSIC_FILES="*.wav|*.ogg|*.mp3|*.m4a";
CFG_OPENGL_DEPTH_BUFFER_ENABLED="1";
CFG_OPENGL_GLES20_ENABLED="1";
CFG_SAFEMODE="0";
CFG_SOUND_FILES="*.wav|*.ogg|*.mp3|*.m4a";
CFG_TARGET="html5";
CFG_TEXT_FILES="*.txt|*.xml|*.json";
//${CONFIG_END}

//${METADATA_BEGIN}
var META_DATA="[mojo_font.png];type=image/png;width=864;height=13;\n[diffuse.jpg];type=image/jpg;width=1024;height=1024;\n[emissive.jpg];type=image/jpg;width=2048;height=2048;\n[normal.jpg];type=image/jpg;width=1024;height=1024;\n[system.png];type=image/png;width=256;height=256;\n";
//${METADATA_END}

//${TRANSCODE_BEGIN}

// Javascript Cerberus runtime.
//
// Placed into the public domain 24/02/2011.
// No warranty implied; use at your own risk.

//***** JavaScript Runtime *****

var D2R=0.017453292519943295;
var R2D=57.29577951308232;

var err_info="";
var err_stack=[];

var dbg_index=0;

function push_err(){
	err_stack.push( err_info );
}

function pop_err(){
	err_info=err_stack.pop();
}

function stackTrace(){
	if( !err_info.length ) return "";
	var str=err_info+"\n";
	for( var i=err_stack.length-1;i>0;--i ){
		str+=err_stack[i]+"\n";
	}
	return str;
}

function print( str ){
	var cons=document.getElementById( "GameConsole" );
	if( cons ){
		cons.value+=str+"\n";
		cons.scrollTop=cons.scrollHeight-cons.clientHeight;
	}else if( window.console!=undefined ){
		window.console.log( str );
	}
	return 0;
}

function alertError( err ){
	if( typeof(err)=="string" && err=="" ) return;
	alert( "Cerberus Runtime Error : "+err.toString()+"\n\n"+stackTrace() );
}

function error( err ){
	throw err;
}

function debugLog( str ){
	if( window.console!=undefined ) window.console.log( str );
}

function debugStop(){
	debugger;	//	error( "STOP" );
}

function dbg_object( obj ){
	if( obj ) return obj;
	error( "Null object access" );
}

function dbg_charCodeAt( str,index ){
	if( index<0 || index>=str.length ) error( "Character index out of range" );
	return str.charCodeAt( index );
}

function dbg_array( arr,index ){
	if( index<0 || index>=arr.length ) error( "Array index out of range" );
	dbg_index=index;
	return arr;
}

function new_bool_array( len ){
	var arr=Array( len );
	for( var i=0;i<len;++i ) arr[i]=false;
	return arr;
}

function new_number_array( len ){
	var arr=Array( len );
	for( var i=0;i<len;++i ) arr[i]=0;
	return arr;
}

function new_string_array( len ){
	var arr=Array( len );
	for( var i=0;i<len;++i ) arr[i]='';
	return arr;
}

function new_array_array( len ){
	var arr=Array( len );
	for( var i=0;i<len;++i ) arr[i]=[];
	return arr;
}

function new_object_array( len ){
	var arr=Array( len );
	for( var i=0;i<len;++i ) arr[i]=null;
	return arr;
}

function resize_bool_array( arr,len ){
	var i=arr.length;
	arr=arr.slice(0,len);
	if( len<=i ) return arr;
	arr.length=len;
	while( i<len ) arr[i++]=false;
	return arr;
}

function resize_number_array( arr,len ){
	var i=arr.length;
	arr=arr.slice(0,len);
	if( len<=i ) return arr;
	arr.length=len;
	while( i<len ) arr[i++]=0;
	return arr;
}

function resize_string_array( arr,len ){
	var i=arr.length;
	arr=arr.slice(0,len);
	if( len<=i ) return arr;
	arr.length=len;
	while( i<len ) arr[i++]="";
	return arr;
}

function resize_array_array( arr,len ){
	var i=arr.length;
	arr=arr.slice(0,len);
	if( len<=i ) return arr;
	arr.length=len;
	while( i<len ) arr[i++]=[];
	return arr;
}

function resize_object_array( arr,len ){
	var i=arr.length;
	arr=arr.slice(0,len);
	if( len<=i ) return arr;
	arr.length=len;
	while( i<len ) arr[i++]=null;
	return arr;
}

function string_compare( lhs,rhs ){
	var n=Math.min( lhs.length,rhs.length ),i,t;
	for( i=0;i<n;++i ){
		t=lhs.charCodeAt(i)-rhs.charCodeAt(i);
		if( t ) return t;
	}
	return lhs.length-rhs.length;
}

function string_replace( str,find,rep ){	//no unregex replace all?!?
	var i=0;
	for(;;){
		i=str.indexOf( find,i );
		if( i==-1 ) return str;
		str=str.substring( 0,i )+rep+str.substring( i+find.length );
		i+=rep.length;
	}
}

function string_trim( str ){
	var i=0,i2=str.length;
	while( i<i2 && str.charCodeAt(i)<=32 ) i+=1;
	while( i2>i && str.charCodeAt(i2-1)<=32 ) i2-=1;
	return str.slice( i,i2 );
}

function string_startswith( str,substr ){
	return substr.length<=str.length && str.slice(0,substr.length)==substr;
}

function string_endswith( str,substr ){
	return substr.length<=str.length && str.slice(str.length-substr.length,str.length)==substr;
}

function string_tochars( str ){
	var arr=new Array( str.length );
	for( var i=0;i<str.length;++i ) arr[i]=str.charCodeAt(i);
	return arr;
}

function string_fromchars( chars ){
	var str="",i;
	for( i=0;i<chars.length;++i ){
		str+=String.fromCharCode( chars[i] );
	}
	return str;
}

function object_downcast( obj,clas ){
	if( obj instanceof clas ) return obj;
	return null;
}

function object_implements( obj,iface ){
	if( obj && obj.implments && obj.implments[iface] ) return obj;
	return null;
}

function extend_class( clas ){
	var tmp=function(){};
	tmp.prototype=clas.prototype;
	return new tmp;
}

function ThrowableObject(){
}

ThrowableObject.prototype.toString=function(){ 
	return "Uncaught Cerberus Exception"; 
}


function BBGameEvent(){}
BBGameEvent.KeyDown=1;
BBGameEvent.KeyUp=2;
BBGameEvent.KeyChar=3;
BBGameEvent.MouseDown=4;
BBGameEvent.MouseUp=5;
BBGameEvent.MouseMove=6;
BBGameEvent.TouchDown=7;
BBGameEvent.TouchUp=8;
BBGameEvent.TouchMove=9;
BBGameEvent.MotionAccel=10;

function BBGameDelegate(){}
BBGameDelegate.prototype.StartGame=function(){}
BBGameDelegate.prototype.SuspendGame=function(){}
BBGameDelegate.prototype.ResumeGame=function(){}
BBGameDelegate.prototype.UpdateGame=function(){}
BBGameDelegate.prototype.RenderGame=function(){}
BBGameDelegate.prototype.KeyEvent=function( ev,data ){}
BBGameDelegate.prototype.MouseEvent=function( ev,data,x,y ){}
BBGameDelegate.prototype.TouchEvent=function( ev,data,x,y ){}
BBGameDelegate.prototype.MotionEvent=function( ev,data,x,y,z ){}
BBGameDelegate.prototype.DiscardGraphics=function(){}

function BBDisplayMode( width,height ){
	this.width=width;
	this.height=height;
}

function BBGame(){
	BBGame._game=this;
	this._delegate=null;
	this._keyboardEnabled=false;
	this._updateRate=0;
	this._started=false;
	this._suspended=false;
	this._debugExs=(CFG_CONFIG=="debug");
	this._startms=Date.now();
}

BBGame.Game=function(){
	return BBGame._game;
}

BBGame.prototype.SetDelegate=function( delegate ){
	this._delegate=delegate;
}

BBGame.prototype.Delegate=function(){
	return this._delegate;
}

BBGame.prototype.SetUpdateRate=function( updateRate ){
	this._updateRate=updateRate;
}

BBGame.prototype.SetKeyboardEnabled=function( keyboardEnabled ){
	this._keyboardEnabled=keyboardEnabled;
}

BBGame.prototype.Started=function(){
	return this._started;
}

BBGame.prototype.Suspended=function(){
	return this._suspended;
}

BBGame.prototype.Millisecs=function(){
	return Date.now()-this._startms;
}

BBGame.prototype.GetDate=function( date ){
	var n=date.length;
	if( n>0 ){
		var t=new Date();
		date[0]=t.getFullYear();
		if( n>1 ){
			date[1]=t.getMonth()+1;
			if( n>2 ){
				date[2]=t.getDate();
				if( n>3 ){
					date[3]=t.getHours();
					if( n>4 ){
						date[4]=t.getMinutes();
						if( n>5 ){
							date[5]=t.getSeconds();
							if( n>6 ){
								date[6]=t.getMilliseconds();
							}
						}
					}
				}
			}
		}
	}
}

BBGame.prototype.SaveState=function( state ){
	localStorage.setItem( "cerberusstate@"+document.URL,state );	//key can't start with dot in Chrome!
	return 1;
}

BBGame.prototype.LoadState=function(){
	var state=localStorage.getItem( "cerberusstate@"+document.URL );
	if( state ) return state;
	return "";
}

BBGame.prototype.LoadString=function( path ){

	var xhr=new XMLHttpRequest();
	xhr.open( "GET",this.PathToUrl( path ),false );
	
//	if( navigator.userAgent.indexOf( "Chrome/48." )>0 ){
//		xhr.setRequestHeader( "If-Modified-Since","Sat, 1 Jan 2000 00:00:00 GMT" );
//	}
	
	xhr.send( null );
	
	if( xhr.status==200 || xhr.status==0 ) return xhr.responseText;
	
	return "";
}

BBGame.prototype.CountJoysticks=function( update ){
	return 0;
}

BBGame.prototype.PollJoystick=function( port,joyx,joyy,joyz,buttons ){
	return false;
}

BBGame.prototype.OpenUrl=function( url ){
	window.location=url;
}

BBGame.prototype.SetMouseVisible=function( visible ){
	if( visible ){
		this._canvas.style.cursor='default';	
	}else{
		this._canvas.style.cursor="url('data:image/cur;base64,AAACAAEAICAAAAAAAACoEAAAFgAAACgAAAAgAAAAQAAAAAEAIAAAAAAAgBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA55ZXBgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOeWVxAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADnllcGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////9////////////////////+////////f/////////8%3D'), auto";
	}
}

BBGame.prototype.GetDeviceWidth=function(){
	return 0;
}

BBGame.prototype.GetDeviceHeight=function(){
	return 0;
}

BBGame.prototype.SetDeviceWindow=function( width,height,flags ){
}

BBGame.prototype.GetDisplayModes=function(){
	return new Array();
}

BBGame.prototype.GetDesktopMode=function(){
	return null;
}

BBGame.prototype.SetSwapInterval=function( interval ){
}

BBGame.prototype.PathToFilePath=function( path ){
	return "";
}

//***** js Game *****

BBGame.prototype.PathToUrl=function( path ){
	return path;
}

BBGame.prototype.LoadData=function( path ){

	var xhr=new XMLHttpRequest();
	xhr.open( "GET",this.PathToUrl( path ),false );

	if( xhr.overrideMimeType ) xhr.overrideMimeType( "text/plain; charset=x-user-defined" );
	
//	if( navigator.userAgent.indexOf( "Chrome/48." )>0 ){
//		xhr.setRequestHeader( "If-Modified-Since","Sat, 1 Jan 2000 00:00:00 GMT" );
//	}

	xhr.send( null );
	if( xhr.status!=200 && xhr.status!=0 ) return null;

	var r=xhr.responseText;
	var buf=new ArrayBuffer( r.length );
	var bytes=new Int8Array( buf );
	for( var i=0;i<r.length;++i ){
		bytes[i]=r.charCodeAt( i );
	}
	return buf;
}

//***** INTERNAL ******

BBGame.prototype.Die=function( ex ){

	this._delegate=new BBGameDelegate();
	
	if( !ex.toString() ){
		return;
	}
	
	if( this._debugExs ){
		print( "Cerberus Runtime Error : "+ex.toString() );
		print( stackTrace() );
	}
	
	throw ex;
}

BBGame.prototype.StartGame=function(){

	if( this._started ) return;
	this._started=true;
	
	if( this._debugExs ){
		try{
			this._delegate.StartGame();
		}catch( ex ){
			this.Die( ex );
		}
	}else{
		this._delegate.StartGame();
	}
}

BBGame.prototype.SuspendGame=function(){

	if( !this._started || this._suspended ) return;
	this._suspended=true;
	
	if( this._debugExs ){
		try{
			this._delegate.SuspendGame();
		}catch( ex ){
			this.Die( ex );
		}
	}else{
		this._delegate.SuspendGame();
	}
}

BBGame.prototype.ResumeGame=function(){

	if( !this._started || !this._suspended ) return;
	this._suspended=false;
	
	if( this._debugExs ){
		try{
			this._delegate.ResumeGame();
		}catch( ex ){
			this.Die( ex );
		}
	}else{
		this._delegate.ResumeGame();
	}
}

BBGame.prototype.UpdateGame=function(){

	if( !this._started || this._suspended ) return;

	if( this._debugExs ){
		try{
			this._delegate.UpdateGame();
		}catch( ex ){
			this.Die( ex );
		}	
	}else{
		this._delegate.UpdateGame();
	}
}

BBGame.prototype.RenderGame=function(){

	if( !this._started ) return;
	
	if( this._debugExs ){
		try{
			this._delegate.RenderGame();
		}catch( ex ){
			this.Die( ex );
		}	
	}else{
		this._delegate.RenderGame();
	}
}

BBGame.prototype.KeyEvent=function( ev,data ){

	if( !this._started ) return;
	
	if( this._debugExs ){
		try{
			this._delegate.KeyEvent( ev,data );
		}catch( ex ){
			this.Die( ex );
		}
	}else{
		this._delegate.KeyEvent( ev,data );
	}
}

BBGame.prototype.MouseEvent=function( ev,data,x,y ){

	if( !this._started ) return;
	
	if( this._debugExs ){
		try{
			this._delegate.MouseEvent( ev,data,x,y );
		}catch( ex ){
			this.Die( ex );
		}
	}else{
		this._delegate.MouseEvent( ev,data,x,y );
	}
}

BBGame.prototype.TouchEvent=function( ev,data,x,y ){

	if( !this._started ) return;
	
	if( this._debugExs ){
		try{
			this._delegate.TouchEvent( ev,data,x,y );
		}catch( ex ){
			this.Die( ex );
		}
	}else{
		this._delegate.TouchEvent( ev,data,x,y );
	}
}

BBGame.prototype.MotionEvent=function( ev,data,x,y,z ){

	if( !this._started ) return;
	
	if( this._debugExs ){
		try{
			this._delegate.MotionEvent( ev,data,x,y,z );
		}catch( ex ){
			this.Die( ex );
		}
	}else{
		this._delegate.MotionEvent( ev,data,x,y,z );
	}
}

BBGame.prototype.DiscardGraphics=function(){

	if( !this._started ) return;
	
	if( this._debugExs ){
		try{
			this._delegate.DiscardGraphics();
		}catch( ex ){
			this.Die( ex );
		}
	}else{
		this._delegate.DiscardGraphics();
	}
}


var webglGraphicsSeq=1;

function BBHtml5Game( canvas ){

	BBGame.call( this );
	BBHtml5Game._game=this;
	this._canvas=canvas;
	this._loading=0;
	this._timerSeq=0;
	this._gl=null;
	
	if( CFG_OPENGL_GLES20_ENABLED=="1" ){

		//can't get these to fire!
		canvas.addEventListener( "webglcontextlost",function( event ){
			event.preventDefault();
//			print( "WebGL context lost!" );
		},false );

		canvas.addEventListener( "webglcontextrestored",function( event ){
			++webglGraphicsSeq;
//			print( "WebGL context restored!" );
		},false );

		var attrs={ alpha:false };
	
		this._gl=this._canvas.getContext( "webgl",attrs );

		if( !this._gl ) this._gl=this._canvas.getContext( "experimental-webgl",attrs );
		
		if( !this._gl ) this.Die( "Can't create WebGL" );
		
		gl=this._gl;
	}
	
	// --- start gamepad api by skn3 ---------
	this._gamepads = null;
	this._gamepadLookup = [-1,-1,-1,-1];//support 4 gamepads
	var that = this;
	window.addEventListener("gamepadconnected", function(e) {
		that.connectGamepad(e.gamepad);
	});
	
	window.addEventListener("gamepaddisconnected", function(e) {
		that.disconnectGamepad(e.gamepad);
	});
	
	//need to process already connected gamepads (before page was loaded)
	var gamepads = this.getGamepads();
	if (gamepads && gamepads.length > 0) {
		for(var index=0;index < gamepads.length;index++) {
			this.connectGamepad(gamepads[index]);
		}
	}
	// --- end gamepad api by skn3 ---------
}

BBHtml5Game.prototype=extend_class( BBGame );

BBHtml5Game.Html5Game=function(){
	return BBHtml5Game._game;
}

// --- start gamepad api by skn3 ---------
BBHtml5Game.prototype.getGamepads = function() {
	return navigator.getGamepads ? navigator.getGamepads() : (navigator.webkitGetGamepads ? navigator.webkitGetGamepads : []);
}

BBHtml5Game.prototype.connectGamepad = function(gamepad) {
	if (!gamepad) {
		return false;
	}
	
	//check if this is a standard gamepad
	if (gamepad.mapping == "standard") {
		//yup so lets add it to an array of valid gamepads
		//find empty controller slot
		var slot = -1;
		for(var index = 0;index < this._gamepadLookup.length;index++) {
			if (this._gamepadLookup[index] == -1) {
				slot = index;
				break;
			}
		}
		
		//can we add this?
		if (slot != -1) {
			this._gamepadLookup[slot] = gamepad.index;
			
			//console.log("gamepad at html5 index "+gamepad.index+" mapped to Cerberus gamepad unit "+slot);
		}
	} else {
		console.log('Cerberus has ignored gamepad at raw port #'+gamepad.index+' with unrecognised mapping scheme \''+gamepad.mapping+'\'.');
	}
}

BBHtml5Game.prototype.disconnectGamepad = function(gamepad) {
	if (!gamepad) {
		return false;
	}
	
	//scan all gamepads for matching index
	for(var index = 0;index < this._gamepadLookup.length;index++) {
		if (this._gamepadLookup[index] == gamepad.index) {
			//remove this gamepad
			this._gamepadLookup[index] = -1
			break;
		}
	}
}

BBHtml5Game.prototype.PollJoystick=function(port, joyx, joyy, joyz, buttons){
	//is this the first gamepad being polled
	if (port == 0) {
		//yes it is so we use the web api to get all gamepad info
		//we can then use this in subsequent calls to PollJoystick
		this._gamepads = this.getGamepads();
	}
	
	//dont bother processing if nothing to process
	if (!this._gamepads) {
	  return false;
	}
	
	//so use the Cerberus port to find the correct raw data
	var index = this._gamepadLookup[port];
	if (index == -1) {
		return false;
	}

	var gamepad = this._gamepads[index];
	if (!gamepad) {
		return false;
	}
	//so now process gamepad axis/buttons according to the standard mappings
	//https://w3c.github.io/gamepad/#remapping
	
	//left stick axis
	joyx[0] = gamepad.axes[0];
	joyy[0] = -gamepad.axes[1];
	
	//right stick axis
	joyx[1] = gamepad.axes[2];
	joyy[1] = -gamepad.axes[3];
	
	//left trigger
	joyz[0] = gamepad.buttons[6] ? gamepad.buttons[6].value : 0.0;
	
	//right trigger
	joyz[1] = gamepad.buttons[7] ? gamepad.buttons[7].value : 0.0;
	
	//clear button states
	for(var index = 0;index <32;index++) {
		buttons[index] = false;
	}
	
	//map html5 "standard" mapping to Cerberuss joy codes
	/*
	Const JOY_A=0
	Const JOY_B=1
	Const JOY_X=2
	Const JOY_Y=3
	Const JOY_LB=4
	Const JOY_RB=5
	Const JOY_BACK=6
	Const JOY_START=7
	Const JOY_LEFT=8
	Const JOY_UP=9
	Const JOY_RIGHT=10
	Const JOY_DOWN=11
	Const JOY_LSB=12
	Const JOY_RSB=13
	Const JOY_MENU=14
	*/
	buttons[0] = gamepad.buttons[0] && gamepad.buttons[0].pressed;
	buttons[1] = gamepad.buttons[1] && gamepad.buttons[1].pressed;
	buttons[2] = gamepad.buttons[2] && gamepad.buttons[2].pressed;
	buttons[3] = gamepad.buttons[3] && gamepad.buttons[3].pressed;
	buttons[4] = gamepad.buttons[4] && gamepad.buttons[4].pressed;
	buttons[5] = gamepad.buttons[5] && gamepad.buttons[5].pressed;
	buttons[6] = gamepad.buttons[8] && gamepad.buttons[8].pressed;
	buttons[7] = gamepad.buttons[9] && gamepad.buttons[9].pressed;
	buttons[8] = gamepad.buttons[14] && gamepad.buttons[14].pressed;
	buttons[9] = gamepad.buttons[12] && gamepad.buttons[12].pressed;
	buttons[10] = gamepad.buttons[15] && gamepad.buttons[15].pressed;
	buttons[11] = gamepad.buttons[13] && gamepad.buttons[13].pressed;
	buttons[12] = gamepad.buttons[10] && gamepad.buttons[10].pressed;
	buttons[13] = gamepad.buttons[11] && gamepad.buttons[11].pressed;
	buttons[14] = gamepad.buttons[16] && gamepad.buttons[16].pressed;
	
	//success
	return true
}
// --- end gamepad api by skn3 ---------


BBHtml5Game.prototype.ValidateUpdateTimer=function(){

	++this._timerSeq;
	if( this._suspended ) return;
	
	var game=this;
	var seq=game._timerSeq;
	
	var maxUpdates=4;
	var updateRate=this._updateRate;
	
	if( !updateRate ){

		var reqAnimFrame=(window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame);
	
		if( reqAnimFrame ){
			function animate(){
				if( seq!=game._timerSeq ) return;
	
				game.UpdateGame();
				if( seq!=game._timerSeq ) return;
	
				reqAnimFrame( animate );
				game.RenderGame();
			}
			reqAnimFrame( animate );
			return;
		}
		
		maxUpdates=1;
		updateRate=60;
	}
	
	var updatePeriod=1000.0/updateRate;
	var nextUpdate=0;

	function timeElapsed(){
		if( seq!=game._timerSeq ) return;
		
		if( !nextUpdate ) nextUpdate=Date.now();
		
		for( var i=0;i<maxUpdates;++i ){
		
			game.UpdateGame();
			if( seq!=game._timerSeq ) return;
			
			nextUpdate+=updatePeriod;
			var delay=nextUpdate-Date.now();
			
			if( delay>0 ){
				setTimeout( timeElapsed,delay );
				game.RenderGame();
				return;
			}
		}
		nextUpdate=0;
		setTimeout( timeElapsed,0 );
		game.RenderGame();
	}

	setTimeout( timeElapsed,0 );
}

//***** BBGame methods *****

BBHtml5Game.prototype.SetUpdateRate=function( updateRate ){

	BBGame.prototype.SetUpdateRate.call( this,updateRate );
	
	this.ValidateUpdateTimer();
}

BBHtml5Game.prototype.GetMetaData=function( path,key ){
	if( path.indexOf( "cerberus://data/" )!=0 ) return "";
	path=path.slice(16);

	var i=META_DATA.indexOf( "["+path+"]" );
	if( i==-1 ) return "";
	i+=path.length+2;

	var e=META_DATA.indexOf( "\n",i );
	if( e==-1 ) e=META_DATA.length;

	i=META_DATA.indexOf( ";"+key+"=",i )
	if( i==-1 || i>=e ) return "";
	i+=key.length+2;

	e=META_DATA.indexOf( ";",i );
	if( e==-1 ) return "";

	return META_DATA.slice( i,e );
}

BBHtml5Game.prototype.PathToUrl=function( path ){
	if( path.indexOf( "cerberus:" )!=0 ){
		return path;
	}else if( path.indexOf( "cerberus://data/" )==0 ) {
		return "data/"+path.slice( 16 );
	}
	return "";
}

BBHtml5Game.prototype.GetLoading=function(){
	return this._loading;
}

BBHtml5Game.prototype.IncLoading=function(){
	++this._loading;
	return this._loading;
}

BBHtml5Game.prototype.DecLoading=function(){
	--this._loading;
	return this._loading;
}

BBHtml5Game.prototype.GetCanvas=function(){
	return this._canvas;
}

BBHtml5Game.prototype.GetWebGL=function(){
	return this._gl;
}

BBHtml5Game.prototype.GetDeviceWidth=function(){
	return this._canvas.width;
}

BBHtml5Game.prototype.GetDeviceHeight=function(){
	return this._canvas.height;
}

//***** INTERNAL *****

BBHtml5Game.prototype.UpdateGame=function(){

	if( !this._loading ) BBGame.prototype.UpdateGame.call( this );
}

BBHtml5Game.prototype.SuspendGame=function(){

	BBGame.prototype.SuspendGame.call( this );
	
	BBGame.prototype.RenderGame.call( this );
	
	this.ValidateUpdateTimer();
}

BBHtml5Game.prototype.ResumeGame=function(){

	BBGame.prototype.ResumeGame.call( this );
	
	this.ValidateUpdateTimer();
}

BBHtml5Game.prototype.Run=function(){

	var game=this;
	var canvas=game._canvas;
	
	var xscale=1;
	var yscale=1;
	
	var touchIds=new Array( 32 );
	for( i=0;i<32;++i ) touchIds[i]=-1;
	
	function eatEvent( e ){
		if( e.stopPropagation ){
			e.stopPropagation();
			e.preventDefault();
		}else{
			e.cancelBubble=true;
			e.returnValue=false;
		}
	}
	
	function keyToChar( key ){
		switch( key ){
		case 8:case 9:case 13:case 27:case 32:return key;
		case 33:case 34:case 35:case 36:case 37:case 38:case 39:case 40:case 45:return key|0x10000;
		case 46:return 127;
		}
		return 0;
	}
	
	function mouseX( e ){
		var x=e.clientX+document.body.scrollLeft;
		var c=canvas;
		while( c ){
			x-=c.offsetLeft;
			c=c.offsetParent;
		}
		return x*xscale;
	}
	
	function mouseY( e ){
		var y=e.clientY+document.body.scrollTop;
		var c=canvas;
		while( c ){
			y-=c.offsetTop;
			c=c.offsetParent;
		}
		return y*yscale;
	}

	function touchX( touch ){
		var x=touch.pageX;
		var c=canvas;
		while( c ){
			x-=c.offsetLeft;
			c=c.offsetParent;
		}
		return x*xscale;
	}			
	
	function touchY( touch ){
		var y=touch.pageY;
		var c=canvas;
		while( c ){
			y-=c.offsetTop;
			c=c.offsetParent;
		}
		return y*yscale;
	}
	
	canvas.onkeydown=function( e ){
		game.KeyEvent( BBGameEvent.KeyDown,e.keyCode );
		var chr=keyToChar( e.keyCode );
		if( chr ) game.KeyEvent( BBGameEvent.KeyChar,chr );
		if( e.keyCode<48 || (e.keyCode>111 && e.keyCode<122) ) eatEvent( e );
	}

	canvas.onkeyup=function( e ){
		game.KeyEvent( BBGameEvent.KeyUp,e.keyCode );
	}

	canvas.onkeypress=function( e ){
		if( e.charCode ){
			game.KeyEvent( BBGameEvent.KeyChar,e.charCode );
		}else if( e.which ){
			game.KeyEvent( BBGameEvent.KeyChar,e.which );
		}
	}

	canvas.onmousedown=function( e ){
		switch( e.button ){
		case 0:game.MouseEvent( BBGameEvent.MouseDown,0,mouseX(e),mouseY(e) );break;
		case 1:game.MouseEvent( BBGameEvent.MouseDown,2,mouseX(e),mouseY(e) );break;
		case 2:game.MouseEvent( BBGameEvent.MouseDown,1,mouseX(e),mouseY(e) );break;
		}
		eatEvent( e );
	}
	
	canvas.onmouseup=function( e ){
		switch( e.button ){
		case 0:game.MouseEvent( BBGameEvent.MouseUp,0,mouseX(e),mouseY(e) );break;
		case 1:game.MouseEvent( BBGameEvent.MouseUp,2,mouseX(e),mouseY(e) );break;
		case 2:game.MouseEvent( BBGameEvent.MouseUp,1,mouseX(e),mouseY(e) );break;
		}
		eatEvent( e );
	}
	
	canvas.onmousemove=function( e ){
		game.MouseEvent( BBGameEvent.MouseMove,-1,mouseX(e),mouseY(e) );
		eatEvent( e );
	}

	canvas.onmouseout=function( e ){
		game.MouseEvent( BBGameEvent.MouseUp,0,mouseX(e),mouseY(e) );
		game.MouseEvent( BBGameEvent.MouseUp,1,mouseX(e),mouseY(e) );
		game.MouseEvent( BBGameEvent.MouseUp,2,mouseX(e),mouseY(e) );
		eatEvent( e );
	}
	
	canvas.onclick=function( e ){
		if( game.Suspended() ){
			canvas.focus();
		}
		eatEvent( e );
		return;
	}
	
	canvas.oncontextmenu=function( e ){
		return false;
	}
	
	canvas.ontouchstart=function( e ){
		if( game.Suspended() ){
			canvas.focus();
		}
		for( var i=0;i<e.changedTouches.length;++i ){
			var touch=e.changedTouches[i];
			for( var j=0;j<32;++j ){
				if( touchIds[j]!=-1 ) continue;
				touchIds[j]=touch.identifier;
				game.TouchEvent( BBGameEvent.TouchDown,j,touchX(touch),touchY(touch) );
				break;
			}
		}
		eatEvent( e );
	}
	
	canvas.ontouchmove=function( e ){
		for( var i=0;i<e.changedTouches.length;++i ){
			var touch=e.changedTouches[i];
			for( var j=0;j<32;++j ){
				if( touchIds[j]!=touch.identifier ) continue;
				game.TouchEvent( BBGameEvent.TouchMove,j,touchX(touch),touchY(touch) );
				break;
			}
		}
		eatEvent( e );
	}
	
	canvas.ontouchend=function( e ){
		for( var i=0;i<e.changedTouches.length;++i ){
			var touch=e.changedTouches[i];
			for( var j=0;j<32;++j ){
				if( touchIds[j]!=touch.identifier ) continue;
				touchIds[j]=-1;
				game.TouchEvent( BBGameEvent.TouchUp,j,touchX(touch),touchY(touch) );
				break;
			}
		}
		eatEvent( e );
	}
	
	window.ondevicemotion=function( e ){
		var tx=e.accelerationIncludingGravity.x/9.81;
		var ty=e.accelerationIncludingGravity.y/9.81;
		var tz=e.accelerationIncludingGravity.z/9.81;
		var x,y;
		switch( window.orientation ){
		case   0:x=+tx;y=-ty;break;
		case 180:x=-tx;y=+ty;break;
		case  90:x=-ty;y=-tx;break;
		case -90:x=+ty;y=+tx;break;
		}
		game.MotionEvent( BBGameEvent.MotionAccel,0,x,y,tz );
		eatEvent( e );
	}

	canvas.onfocus=function( e ){
		if( CFG_MOJO_AUTO_SUSPEND_ENABLED=="1" ){
			game.ResumeGame();
		}else{
			game.ValidateUpdateTimer();
		}
	}
	
	canvas.onblur=function( e ){
		for( var i=0;i<256;++i ) game.KeyEvent( BBGameEvent.KeyUp,i );
		if( CFG_MOJO_AUTO_SUSPEND_ENABLED=="1" ){
			game.SuspendGame();
		}
	}

	canvas.updateSize=function(){
		xscale=canvas.width/canvas.clientWidth;
		yscale=canvas.height/canvas.clientHeight;
		game.RenderGame();
	}
	
	canvas.updateSize();
	
	canvas.focus();
	
	game.StartGame();
	
	game.RenderGame();
}


function BBCerberusGame( canvas ){
	BBHtml5Game.call( this,canvas );
}

BBCerberusGame.prototype=extend_class( BBHtml5Game );

BBCerberusGame.Main=function( canvas ){

	var game=new BBCerberusGame( canvas );

	try{

		bbInit();
		bbMain();

	}catch( ex ){
	
		game.Die( ex );
		return;
	}

	if( !game.Delegate() ) return;
	
	game.Run();
}


// HTML5 mojo runtime.
//
// Copyright 2011 Mark Sibly, all rights reserved.
// No warranty implied; use at your own risk.

// ***** gxtkGraphics class *****

function gxtkGraphics(){
	this.game=BBHtml5Game.Html5Game();
	this.canvas=this.game.GetCanvas()
	this.width=this.canvas.width;
	this.height=this.canvas.height;
	this.gl=null;
	this.gc=this.canvas.getContext( '2d' );
	this.tmpCanvas=null;
	this.r=255;
	this.b=255;
	this.g=255;
	this.white=true;
	this.color="rgb(255,255,255)"
	this.alpha=1;
	this.blend="source-over";
	this.ix=1;this.iy=0;
	this.jx=0;this.jy=1;
	this.tx=0;this.ty=0;
	this.tformed=false;
	this.scissorX=0;
	this.scissorY=0;
	this.scissorWidth=0;
	this.scissorHeight=0;
	this.clipped=false;
}

gxtkGraphics.prototype.BeginRender=function(){
	this.width=this.canvas.width;
	this.height=this.canvas.height;
	if( !this.gc ) return 0;
	this.gc.save();
	if( this.game.GetLoading() ) return 2;
	return 1;
}

gxtkGraphics.prototype.EndRender=function(){
	if( this.gc ) this.gc.restore();
}

gxtkGraphics.prototype.Width=function(){
	return this.width;
}

gxtkGraphics.prototype.Height=function(){
	return this.height;
}

gxtkGraphics.prototype.LoadSurface=function( path ){
	var game=this.game;

	var ty=game.GetMetaData( path,"type" );
	if( ty.indexOf( "image/" )!=0 ) return null;
	
	game.IncLoading();

	var image=new Image();
	image.onload=function(){ game.DecLoading(); }
	image.onerror=function(){ game.DecLoading(); }
	image.meta_width=parseInt( game.GetMetaData( path,"width" ) );
	image.meta_height=parseInt( game.GetMetaData( path,"height" ) );
	image.src=game.PathToUrl( path );

	return new gxtkSurface( image,this );
}

gxtkGraphics.prototype.CreateSurface=function( width,height ){
	var canvas=document.createElement( 'canvas' );
	
	canvas.width=width;
	canvas.height=height;
	canvas.meta_width=width;
	canvas.meta_height=height;
	canvas.complete=true;
	
	var surface=new gxtkSurface( canvas,this );
	
	surface.gc=canvas.getContext( '2d' );
	
	return surface;
}

gxtkGraphics.prototype.SetAlpha=function( alpha ){
	this.alpha=alpha;
	this.gc.globalAlpha=alpha;
}

gxtkGraphics.prototype.SetColor=function( r,g,b ){
	this.r=r;
	this.g=g;
	this.b=b;
	this.white=(r==255 && g==255 && b==255);
	this.color="rgb("+(r|0)+","+(g|0)+","+(b|0)+")";
	this.gc.fillStyle=this.color;
	this.gc.strokeStyle=this.color;
}

gxtkGraphics.prototype.SetBlend=function( blend ){
	switch( blend ){
	case 1:
		this.blend="lighter";
		break;
	default:
		this.blend="source-over";
	}
	this.gc.globalCompositeOperation=this.blend;
}

gxtkGraphics.prototype.SetScissor=function( x,y,w,h ){
	this.scissorX=x;
	this.scissorY=y;
	this.scissorWidth=w;
	this.scissorHeight=h;
	this.clipped=(x!=0 || y!=0 || w!=this.canvas.width || h!=this.canvas.height);
	this.gc.restore();
	this.gc.save();
	if( this.clipped ){
		this.gc.beginPath();
		this.gc.rect( x,y,w,h );
		this.gc.clip();
		this.gc.closePath();
	}
	this.gc.fillStyle=this.color;
	this.gc.strokeStyle=this.color;	
	this.gc.globalAlpha=this.alpha;	
	this.gc.globalCompositeOperation=this.blend;
	if( this.tformed ) this.gc.setTransform( this.ix,this.iy,this.jx,this.jy,this.tx,this.ty );
}

gxtkGraphics.prototype.SetMatrix=function( ix,iy,jx,jy,tx,ty ){
	this.ix=ix;this.iy=iy;
	this.jx=jx;this.jy=jy;
	this.tx=tx;this.ty=ty;
	this.gc.setTransform( ix,iy,jx,jy,tx,ty );
	this.tformed=(ix!=1 || iy!=0 || jx!=0 || jy!=1 || tx!=0 || ty!=0);
}

gxtkGraphics.prototype.Cls=function( r,g,b ){
	if( this.tformed ) this.gc.setTransform( 1,0,0,1,0,0 );
	this.gc.fillStyle="rgb("+(r|0)+","+(g|0)+","+(b|0)+")";
	this.gc.globalAlpha=1;
	this.gc.globalCompositeOperation="source-over";
	this.gc.fillRect( 0,0,this.canvas.width,this.canvas.height );
	this.gc.fillStyle=this.color;
	this.gc.globalAlpha=this.alpha;
	this.gc.globalCompositeOperation=this.blend;
	if( this.tformed ) this.gc.setTransform( this.ix,this.iy,this.jx,this.jy,this.tx,this.ty );
}

gxtkGraphics.prototype.DrawPoint=function( x,y ){
	if( this.tformed ){
		var px=x;
		x=px * this.ix + y * this.jx + this.tx;
		y=px * this.iy + y * this.jy + this.ty;
		this.gc.setTransform( 1,0,0,1,0,0 );
		this.gc.fillRect( x,y,1,1 );
		this.gc.setTransform( this.ix,this.iy,this.jx,this.jy,this.tx,this.ty );
	}else{
		this.gc.fillRect( x,y,1,1 );
	}
}

gxtkGraphics.prototype.DrawRect=function( x,y,w,h ){
	if( w<0 ){ x+=w;w=-w; }
	if( h<0 ){ y+=h;h=-h; }
	if( w<=0 || h<=0 ) return;
	//
	this.gc.fillRect( x,y,w,h );
}

gxtkGraphics.prototype.DrawLine=function( x1,y1,x2,y2 ){
	if( this.tformed ){
		var x1_t=x1 * this.ix + y1 * this.jx + this.tx;
		var y1_t=x1 * this.iy + y1 * this.jy + this.ty;
		var x2_t=x2 * this.ix + y2 * this.jx + this.tx;
		var y2_t=x2 * this.iy + y2 * this.jy + this.ty;
		this.gc.setTransform( 1,0,0,1,0,0 );
	  	this.gc.beginPath();
	  	this.gc.moveTo( x1_t,y1_t );
	  	this.gc.lineTo( x2_t,y2_t );
	  	this.gc.stroke();
	  	this.gc.closePath();
		this.gc.setTransform( this.ix,this.iy,this.jx,this.jy,this.tx,this.ty );
	}else{
	  	this.gc.beginPath();
	  	this.gc.moveTo( x1,y1 );
	  	this.gc.lineTo( x2,y2 );
	  	this.gc.stroke();
	  	this.gc.closePath();
	}
}

gxtkGraphics.prototype.DrawOval=function( x,y,w,h ){
	if( w<0 ){ x+=w;w=-w; }
	if( h<0 ){ y+=h;h=-h; }
	if( w<=0 || h<=0 ) return;
	//
  	var w2=w/2,h2=h/2;
	this.gc.save();
	this.gc.translate( x+w2,y+h2 );
	this.gc.scale( w2,h2 );
  	this.gc.beginPath();
	this.gc.arc( 0,0,1,0,Math.PI*2,false );
	this.gc.fill();
  	this.gc.closePath();
	this.gc.restore();
}

gxtkGraphics.prototype.DrawPoly=function( verts ){
	if( verts.length<2 ) return;
	this.gc.beginPath();
	this.gc.moveTo( verts[0],verts[1] );
	for( var i=2;i<verts.length;i+=2 ){
		this.gc.lineTo( verts[i],verts[i+1] );
	}
	this.gc.fill();
	this.gc.closePath();
}

gxtkGraphics.prototype.DrawPoly2=function( verts,surface,srx,srcy ){
	if( verts.length<4 ) return;
	this.gc.beginPath();
	this.gc.moveTo( verts[0],verts[1] );
	for( var i=4;i<verts.length;i+=4 ){
		this.gc.lineTo( verts[i],verts[i+1] );
	}
	this.gc.fill();
	this.gc.closePath();
}

gxtkGraphics.prototype.DrawSurface=function( surface,x,y ){
	if( !surface.image.complete ) return;
	
	if( this.white ){
		this.gc.drawImage( surface.image,x,y );
		return;
	}
	
	this.DrawImageTinted( surface.image,x,y,0,0,surface.swidth,surface.sheight );
}

gxtkGraphics.prototype.DrawSurface2=function( surface,x,y,srcx,srcy,srcw,srch ){
	if( !surface.image.complete ) return;

	if( srcw<0 ){ srcx+=srcw;srcw=-srcw; }
	if( srch<0 ){ srcy+=srch;srch=-srch; }
	if( srcw<=0 || srch<=0 ) return;

	if( this.white ){
		this.gc.drawImage( surface.image,srcx,srcy,srcw,srch,x,y,srcw,srch );
		return;
	}
	
	this.DrawImageTinted( surface.image,x,y,srcx,srcy,srcw,srch  );
}

gxtkGraphics.prototype.DrawImageTinted=function( image,dx,dy,sx,sy,sw,sh ){

	if( !this.tmpCanvas ){
		this.tmpCanvas=document.createElement( "canvas" );
	}

	if( sw>this.tmpCanvas.width || sh>this.tmpCanvas.height ){
		this.tmpCanvas.width=Math.max( sw,this.tmpCanvas.width );
		this.tmpCanvas.height=Math.max( sh,this.tmpCanvas.height );
	}
	
	var tmpGC=this.tmpCanvas.getContext( "2d" );
	tmpGC.globalCompositeOperation="copy";
	
	tmpGC.drawImage( image,sx,sy,sw,sh,0,0,sw,sh );
	
	var imgData=tmpGC.getImageData( 0,0,sw,sh );
	
	var p=imgData.data,sz=sw*sh*4,i;
	
	for( i=0;i<sz;i+=4 ){
		p[i]=p[i]*this.r/255;
		p[i+1]=p[i+1]*this.g/255;
		p[i+2]=p[i+2]*this.b/255;
	}
	
	tmpGC.putImageData( imgData,0,0 );
	
	this.gc.drawImage( this.tmpCanvas,0,0,sw,sh,dx,dy,sw,sh );
}

gxtkGraphics.prototype.ReadPixels=function( pixels,x,y,width,height,offset,pitch ){

	var imgData=this.gc.getImageData( x,y,width,height );
	
	var p=imgData.data,i=0,j=offset,px,py;
	
	for( py=0;py<height;++py ){
		for( px=0;px<width;++px ){
			pixels[j++]=(p[i+3]<<24)|(p[i]<<16)|(p[i+1]<<8)|p[i+2];
			i+=4;
		}
		j+=pitch-width;
	}
}

gxtkGraphics.prototype.WritePixels2=function( surface,pixels,x,y,width,height,offset,pitch ){

	if( !surface.gc ){
		if( !surface.image.complete ) return;
		var canvas=document.createElement( "canvas" );
		canvas.width=surface.swidth;
		canvas.height=surface.sheight;
		surface.gc=canvas.getContext( "2d" );
		surface.gc.globalCompositeOperation="copy";
		surface.gc.drawImage( surface.image,0,0 );
		surface.image=canvas;
	}

	var imgData=surface.gc.createImageData( width,height );

	var p=imgData.data,i=0,j=offset,px,py,argb;
	
	for( py=0;py<height;++py ){
		for( px=0;px<width;++px ){
			argb=pixels[j++];
			p[i]=(argb>>16) & 0xff;
			p[i+1]=(argb>>8) & 0xff;
			p[i+2]=argb & 0xff;
			p[i+3]=(argb>>24) & 0xff;
			i+=4;
		}
		j+=pitch-width;
	}
	
	surface.gc.putImageData( imgData,x,y );
}

// ***** gxtkSurface class *****

function gxtkSurface( image,graphics ){
	this.image=image;
	this.graphics=graphics;
	this.swidth=image.meta_width;
	this.sheight=image.meta_height;
}

// ***** GXTK API *****

gxtkSurface.prototype.Discard=function(){
	if( this.image ){
		this.image=null;
	}
}

gxtkSurface.prototype.Width=function(){
	return this.swidth;
}

gxtkSurface.prototype.Height=function(){
	return this.sheight;
}

gxtkSurface.prototype.Loaded=function(){
	return this.image.complete;
}

gxtkSurface.prototype.OnUnsafeLoadComplete=function(){
}

if( CFG_HTML5_WEBAUDIO_ENABLED=="1" && (window.AudioContext || window.webkitAudioContext) ){

//print( "Using WebAudio!" );

// ***** WebAudio *****

var wa=null;

// ***** WebAudio gxtkSample *****

var gxtkSample=function(){
	this.waBuffer=null;
	this.state=0;
}

gxtkSample.prototype.Load=function( path ){
	if( this.state ) return false;

	var req=new XMLHttpRequest();
	
	req.open( "get",BBGame.Game().PathToUrl( path ),true );
	req.responseType="arraybuffer";
	
	var abuf=this;
	
	req.onload=function(){
		wa.decodeAudioData( req.response,function( buffer ){
			//success!
			abuf.waBuffer=buffer;
			abuf.state=1;
		},function(){
			abuf.state=-1;
		} );
	}
	
	req.onerror=function(){
		abuf.state=-1;
	}
	
	req.send();
	
	this.state=2;
			
	return true;
}

gxtkSample.prototype.Discard=function(){
}

// ***** WebAudio gxtkChannel *****

var gxtkChannel=function(){
	this.buffer=null;
	this.flags=0;
	this.volume=1;
	this.pan=0;
	this.rate=1;
	this.waSource=null;
	this.waPan=wa.create
	this.waGain=wa.createGain();
	this.waGain.connect( wa.destination );
	this.waPanner=wa.createPanner();
	this.waPanner.rolloffFactor=0;
	this.waPanner.panningModel="equalpower";
	this.waPanner.connect( this.waGain );
	this.startTime=0;
	this.offset=0;
	this.state=0;
}

// ***** WebAudio gxtkAudio *****

var gxtkAudio=function(){

	if( !wa ){
		window.AudioContext=window.AudioContext || window.webkitAudioContext;
		wa=new AudioContext();
	}
	
	this.okay=true;
	this.music=null;
	this.musicState=0;
	this.musicVolume=1;
	this.channels=new Array();
	for( var i=0;i<32;++i ){
		this.channels[i]=new gxtkChannel();
	}
}

gxtkAudio.prototype.Suspend=function(){
	if( this.MusicState()==1 ) this.music.pause();
	for( var i=0;i<32;++i ){
		var chan=this.channels[i];
		if( chan.state!=1 ) continue;
		this.PauseChannel( i );
		chan.state=5;
	}
}

gxtkAudio.prototype.Resume=function(){
	if( this.MusicState()==1 ) this.music.play();
	for( var i=0;i<32;++i ){
		var chan=this.channels[i];
		if( chan.state!=5 ) continue;
		chan.state=2;
		this.ResumeChannel( i );
	}
}

gxtkAudio.prototype.LoadSample=function( path ){

	var sample=new gxtkSample();
	if( !sample.Load( BBHtml5Game.Html5Game().PathToUrl( path ) ) ) return null;
	
	return sample;
}

gxtkAudio.prototype.PlaySample=function( buffer,channel,flags ){

	if( buffer.state!=1 ) return;

	var chan=this.channels[channel];
	
	if( chan.state ){
		chan.waSource.onended=null
		try {
			chan.waSource.stop( 0 );
			chan.state = 0			
		} catch (err) {			
		}
	}
	
	chan.buffer=buffer;
	chan.flags=flags;

	chan.waSource=wa.createBufferSource();
	chan.waSource.buffer=buffer.waBuffer;
	chan.waSource.playbackRate.value=chan.rate;
	chan.waSource.loop=(flags&1)!=0;
	chan.waSource.connect( chan.waPanner );
	
	chan.waSource.onended=function( e ){
		chan.waSource=null;
		chan.state=0;
	}

	chan.offset=0;	
	chan.startTime=wa.currentTime;
	chan.waSource.start( 0 );

	chan.state=1;
}

gxtkAudio.prototype.StopChannel=function( channel ){

	var chan=this.channels[channel];
	if( !chan.state ) return;
	
	if( chan.state==1 ){
		chan.waSource.onended=null;
		try {
			chan.waSource.stop( 0 );
		} catch (err) {			
		}
		chan.waSource=null;
	}

	chan.state=0;
}

gxtkAudio.prototype.PauseChannel=function( channel ){

	var chan=this.channels[channel];
	if( chan.state!=1 ) return;
	
	chan.offset=(chan.offset+(wa.currentTime-chan.startTime)*chan.rate)%chan.buffer.waBuffer.duration;
	
	chan.waSource.onended=null;
	try {
		chan.waSource.stop( 0 );
	} catch (err) {			
	}
	chan.waSource=null;
	
	chan.state=2;
}

gxtkAudio.prototype.ResumeChannel=function( channel ){

	var chan=this.channels[channel];
	if( chan.state!=2 ) return;
	
	chan.waSource=wa.createBufferSource();
	chan.waSource.buffer=chan.buffer.waBuffer;
	chan.waSource.playbackRate.value=chan.rate;
	chan.waSource.loop=(chan.flags&1)!=0;
	chan.waSource.connect( chan.waPanner );
	
	chan.waSource.onended=function( e ){
		chan.waSource=null;
		chan.state=0;
	}
	
	chan.startTime=wa.currentTime;
	chan.waSource.start( 0,chan.offset );

	chan.state=1;
}

gxtkAudio.prototype.ChannelState=function( channel ){
	return this.channels[channel].state & 3;
}

gxtkAudio.prototype.SetVolume=function( channel,volume ){
	var chan=this.channels[channel];

	chan.volume=volume;
	
	chan.waGain.gain.value=volume;
}

gxtkAudio.prototype.SetPan=function( channel,pan ){
	var chan=this.channels[channel];

	chan.pan=pan;
	
	var sin=Math.sin( pan*3.14159265359/2 );
	var cos=Math.cos( pan*3.14159265359/2 );
	
	chan.waPanner.setPosition( sin,0,-cos );
}

gxtkAudio.prototype.SetRate=function( channel,rate ){

	var chan=this.channels[channel];

	if( chan.state==1 ){
		//update offset for pause/resume
		var time=wa.currentTime;
		chan.offset=(chan.offset+(time-chan.startTime)*chan.rate)%chan.buffer.waBuffer.duration;
		chan.startTime=time;
	}

	chan.rate=rate;
	
	if( chan.waSource ) chan.waSource.playbackRate.value=rate;
}

gxtkAudio.prototype.PlayMusic=function( path,flags ){
	if( this.musicState ) this.music.pause();
	this.music=new Audio( BBGame.Game().PathToUrl( path ) );
	this.music.loop=(flags&1)!=0;
	this.music.play();
	this.musicState=1;
}

gxtkAudio.prototype.StopMusic=function(){
	if( !this.musicState ) return;
	this.music.pause();
	this.music=null;
	this.musicState=0;
}

gxtkAudio.prototype.PauseMusic=function(){
	if( this.musicState!=1 ) return;
	this.music.pause();
	this.musicState=2;
}

gxtkAudio.prototype.ResumeMusic=function(){
	if( this.musicState!=2 ) return;
	this.music.play();
	this.musicState=1;
}

gxtkAudio.prototype.MusicState=function(){
	if( this.musicState==1 && this.music.ended && !this.music.loop ){
		this.music=null;
		this.musicState=0;
	}
	return this.musicState;
}

gxtkAudio.prototype.SetMusicVolume=function( volume ){
	this.musicVolume=volume;
	if( this.musicState ) this.music.volume=volume;
}

}else{

//print( "Using OldAudio!" );

// ***** gxtkChannel class *****

var gxtkChannel=function(){
	this.sample=null;
	this.audio=null;
	this.volume=1;
	this.pan=0;
	this.rate=1;
	this.flags=0;
	this.state=0;
}

// ***** gxtkAudio class *****

var gxtkAudio=function(){
	this.game=BBHtml5Game.Html5Game();
	this.okay=typeof(Audio)!="undefined";
	this.music=null;
	this.channels=new Array(33);
	for( var i=0;i<33;++i ){
		this.channels[i]=new gxtkChannel();
		if( !this.okay ) this.channels[i].state=-1;
	}
}

gxtkAudio.prototype.Suspend=function(){
	var i;
	for( i=0;i<33;++i ){
		var chan=this.channels[i];
		if( chan.state==1 ){
			if( chan.audio.ended && !chan.audio.loop ){
				chan.state=0;
			}else{
				chan.audio.pause();
				chan.state=3;
			}
		}
	}
}

gxtkAudio.prototype.Resume=function(){
	var i;
	for( i=0;i<33;++i ){
		var chan=this.channels[i];
		if( chan.state==3 ){
			chan.audio.play();
			chan.state=1;
		}
	}
}

gxtkAudio.prototype.LoadSample=function( path ){
	if( !this.okay ) return null;

	var audio=new Audio( this.game.PathToUrl( path ) );
	if( !audio ) return null;
	
	return new gxtkSample( audio );
}

gxtkAudio.prototype.PlaySample=function( sample,channel,flags ){
	if( !this.okay ) return;
	
	var chan=this.channels[channel];

	if( chan.state>0 ){
		chan.audio.pause();
		chan.state=0;
	}
	
	for( var i=0;i<33;++i ){
		var chan2=this.channels[i];
		if( chan2.state==1 && chan2.audio.ended && !chan2.audio.loop ) chan.state=0;
		if( chan2.state==0 && chan2.sample ){
			chan2.sample.FreeAudio( chan2.audio );
			chan2.sample=null;
			chan2.audio=null;
		}
	}

	var audio=sample.AllocAudio();
	if( !audio ) return;

	audio.loop=(flags&1)!=0;
	audio.volume=chan.volume;
	audio.play();

	chan.sample=sample;
	chan.audio=audio;
	chan.flags=flags;
	chan.state=1;
}

gxtkAudio.prototype.StopChannel=function( channel ){
	var chan=this.channels[channel];
	
	if( chan.state>0 ){
		chan.audio.pause();
		chan.state=0;
	}
}

gxtkAudio.prototype.PauseChannel=function( channel ){
	var chan=this.channels[channel];
	
	if( chan.state==1 ){
		if( chan.audio.ended && !chan.audio.loop ){
			chan.state=0;
		}else{
			chan.audio.pause();
			chan.state=2;
		}
	}
}

gxtkAudio.prototype.ResumeChannel=function( channel ){
	var chan=this.channels[channel];
	
	if( chan.state==2 ){
		chan.audio.play();
		chan.state=1;
	}
}

gxtkAudio.prototype.ChannelState=function( channel ){
	var chan=this.channels[channel];
	if( chan.state==1 && chan.audio.ended && !chan.audio.loop ) chan.state=0;
	if( chan.state==3 ) return 1;
	return chan.state;
}

gxtkAudio.prototype.SetVolume=function( channel,volume ){
	var chan=this.channels[channel];
	if( chan.state>0 ) chan.audio.volume=volume;
	chan.volume=volume;
}

gxtkAudio.prototype.SetPan=function( channel,pan ){
	var chan=this.channels[channel];
	chan.pan=pan;
}

gxtkAudio.prototype.SetRate=function( channel,rate ){
	var chan=this.channels[channel];
	chan.rate=rate;
}

gxtkAudio.prototype.PlayMusic=function( path,flags ){
	this.StopMusic();
	
	this.music=this.LoadSample( path );
	if( !this.music ) return;
	
	this.PlaySample( this.music,32,flags );
}

gxtkAudio.prototype.StopMusic=function(){
	this.StopChannel( 32 );

	if( this.music ){
		this.music.Discard();
		this.music=null;
	}
}

gxtkAudio.prototype.PauseMusic=function(){
	this.PauseChannel( 32 );
}

gxtkAudio.prototype.ResumeMusic=function(){
	this.ResumeChannel( 32 );
}

gxtkAudio.prototype.MusicState=function(){
	return this.ChannelState( 32 );
}

gxtkAudio.prototype.SetMusicVolume=function( volume ){
	this.SetVolume( 32,volume );
}

// ***** gxtkSample class *****

//function gxtkSample( audio ){
var gxtkSample=function( audio ){
	this.audio=audio;
	this.free=new Array();
	this.insts=new Array();
}

gxtkSample.prototype.FreeAudio=function( audio ){
	this.free.push( audio );
}

gxtkSample.prototype.AllocAudio=function(){
	var audio;
	while( this.free.length ){
		audio=this.free.pop();
		try{
			audio.currentTime=0;
			return audio;
		}catch( ex ){
//			print( "AUDIO ERROR1!" );
		}
	}
	
	//Max out?
	if( this.insts.length==8 ) return null;
	
	audio=new Audio( this.audio.src );
	
	//yucky loop handler for firefox!
	//
	audio.addEventListener( 'ended',function(){
		if( this.loop ){
			try{
				this.currentTime=0;
				this.play();
			}catch( ex ){
//				print( "AUDIO ERROR2!" );
			}
		}
	},false );

	this.insts.push( audio );
	return audio;
}

gxtkSample.prototype.Discard=function(){
}

}


function BBThread(){
	this.result=null;
	this.running=false;
}

BBThread.prototype.Start=function(){
	this.result=null;
	this.running=true;
	this.Run__UNSAFE__();
}

BBThread.prototype.IsRunning=function(){
	return this.running;
}

BBThread.prototype.Result=function(){
	return this.result;
}

BBThread.prototype.Run__UNSAFE__=function(){
	this.running=false;
}


function BBDataBuffer(){
	this.arrayBuffer=null;
	this.length=0;
}

BBDataBuffer.tbuf=new ArrayBuffer(4);
BBDataBuffer.tbytes=new Int8Array( BBDataBuffer.tbuf );
BBDataBuffer.tshorts=new Int16Array( BBDataBuffer.tbuf );
BBDataBuffer.tints=new Int32Array( BBDataBuffer.tbuf );
BBDataBuffer.tfloats=new Float32Array( BBDataBuffer.tbuf );

BBDataBuffer.prototype._Init=function( buffer ){
  
  this.length=buffer.byteLength;
  
  if (buffer.byteLength != Math.ceil(buffer.byteLength / 4) * 4)
  {
    var new_buffer = new ArrayBuffer(Math.ceil(buffer.byteLength / 4) * 4);
    var src = new Int8Array(buffer);
    var dst = new Int8Array(new_buffer);
    for (var i = 0; i < this.length; i++) {
      dst[i] = src[i];
    }
    buffer = new_buffer;    
  }

	this.arrayBuffer=buffer;
	this.bytes=new Int8Array( buffer );	
	this.shorts=new Int16Array( buffer,0,this.length/2 );	
	this.ints=new Int32Array( buffer,0,this.length/4 );	
	this.floats=new Float32Array( buffer,0,this.length/4 );
}

BBDataBuffer.prototype._New=function( length ){
	if( this.arrayBuffer ) return false;
	
	var buf=new ArrayBuffer( length );
	if( !buf ) return false;
	
	this._Init( buf );
	return true;
}

BBDataBuffer.prototype._Load=function( path ){
	if( this.arrayBuffer ) return false;
	
	var buf=BBGame.Game().LoadData( path );
	if( !buf ) return false;
	
	this._Init( buf );
	return true;
}

BBDataBuffer.prototype._LoadAsync=function( path,thread ){

	var buf=this;
	
	var xhr=new XMLHttpRequest();
	xhr.open( "GET",BBGame.Game().PathToUrl( path ),true );
	xhr.responseType="arraybuffer";
	
	xhr.onload=function(e){
		if( this.status==200 || this.status==0 ){
			buf._Init( xhr.response );
			thread.result=buf;
		}
		thread.running=false;
	}
	
	xhr.onerror=function(e){
		thread.running=false;
	}
	
	xhr.send();
}


BBDataBuffer.prototype.GetArrayBuffer=function(){
	return this.arrayBuffer;
}

BBDataBuffer.prototype.Length=function(){
	return this.length;
}

BBDataBuffer.prototype.Discard=function(){
	if( this.arrayBuffer ){
		this.arrayBuffer=null;
		this.length=0;
	}
}

BBDataBuffer.prototype.PokeByte=function( addr,value ){
	this.bytes[addr]=value;
}

BBDataBuffer.prototype.PokeShort=function( addr,value ){
	if( addr&1 ){
		BBDataBuffer.tshorts[0]=value;
		this.bytes[addr]=BBDataBuffer.tbytes[0];
		this.bytes[addr+1]=BBDataBuffer.tbytes[1];
		return;
	}
	this.shorts[addr>>1]=value;
}

BBDataBuffer.prototype.PokeInt=function( addr,value ){
	if( addr&3 ){
		BBDataBuffer.tints[0]=value;
		this.bytes[addr]=BBDataBuffer.tbytes[0];
		this.bytes[addr+1]=BBDataBuffer.tbytes[1];
		this.bytes[addr+2]=BBDataBuffer.tbytes[2];
		this.bytes[addr+3]=BBDataBuffer.tbytes[3];
		return;
	}
	this.ints[addr>>2]=value;
}

BBDataBuffer.prototype.PokeFloat=function( addr,value ){
	if( addr&3 ){
		BBDataBuffer.tfloats[0]=value;
		this.bytes[addr]=BBDataBuffer.tbytes[0];
		this.bytes[addr+1]=BBDataBuffer.tbytes[1];
		this.bytes[addr+2]=BBDataBuffer.tbytes[2];
		this.bytes[addr+3]=BBDataBuffer.tbytes[3];
		return;
	}
	this.floats[addr>>2]=value;
}

BBDataBuffer.prototype.PeekByte=function( addr ){
	return this.bytes[addr];
}

BBDataBuffer.prototype.PeekShort=function( addr ){
	if( addr&1 ){
		BBDataBuffer.tbytes[0]=this.bytes[addr];
		BBDataBuffer.tbytes[1]=this.bytes[addr+1];
		return BBDataBuffer.tshorts[0];
	}
	return this.shorts[addr>>1];
}

BBDataBuffer.prototype.PeekInt=function( addr ){
	if( addr&3 ){
		BBDataBuffer.tbytes[0]=this.bytes[addr];
		BBDataBuffer.tbytes[1]=this.bytes[addr+1];
		BBDataBuffer.tbytes[2]=this.bytes[addr+2];
		BBDataBuffer.tbytes[3]=this.bytes[addr+3];
		return BBDataBuffer.tints[0];
	}
	return this.ints[addr>>2];
}

BBDataBuffer.prototype.PeekFloat=function( addr ){
	if( addr&3 ){
		BBDataBuffer.tbytes[0]=this.bytes[addr];
		BBDataBuffer.tbytes[1]=this.bytes[addr+1];
		BBDataBuffer.tbytes[2]=this.bytes[addr+2];
		BBDataBuffer.tbytes[3]=this.bytes[addr+3];
		return BBDataBuffer.tfloats[0];
	}
	return this.floats[addr>>2];
}


var bb_texs_loading=0;

function BBLoadStaticTexImage( path,info ){

	var game=BBHtml5Game.Html5Game();

	var ty=game.GetMetaData( path,"type" );
	if( ty.indexOf( "image/" )!=0 ) return null;
	
	if( info.length>0 ) info[0]=parseInt( game.GetMetaData( path,"width" ) );
	if( info.length>1 ) info[1]=parseInt( game.GetMetaData( path,"height" ) );
	
	var img=new Image();
	img.src=game.PathToUrl( path );
	
	return img;
}

function BBTextureLoading( tex ){
	return tex && tex._loading;
}

function BBTexturesLoading(){
	return bb_texs_loading;
}

function _glGenerateMipmap( target ){

	var tex=gl.getParameter( gl.TEXTURE_BINDING_2D );
	
	if( tex && tex._loading ){
		tex._genmipmap=true;
	}else{
		gl.generateMipmap( target );
	}
}

function _glBindTexture( target,tex ){
	if( tex ){
		gl.bindTexture( target,tex );
	}else{
		gl.bindTexture( target,null );
	}
}

function _glTexImage2D( target,level,internalformat,width,height,border,format,type,pixels ){

	gl.texImage2D( target,level,internalformat,width,height,border,format,type,pixels ? new Uint8Array(pixels.arrayBuffer) : null );
}

function _glTexImage2D2( target,level,internalformat,format,type,img ){

	if( img.complete ){
		gl.pixelStorei( gl.UNPACK_PREMULTIPLY_ALPHA_WEBGL,true );	
		gl.texImage2D( target,level,internalformat,format,type,img );
		gl.pixelStorei( gl.UNPACK_PREMULTIPLY_ALPHA_WEBGL,false );	
		return;
	}
	
	var tex=gl.getParameter( gl.TEXTURE_BINDING_2D );
	if( 	tex._loading ){
		tex._loading+=1;
	}else{
		tex._loading=1;
	}

	bb_texs_loading+=1;
	
	var onload=function(){
	
		var tmp=gl.getParameter( gl.TEXTURE_BINDING_2D );
		gl.bindTexture( target,tex );
		
		gl.pixelStorei( gl.UNPACK_PREMULTIPLY_ALPHA_WEBGL,true );	
		gl.texImage2D( target,level,internalformat,format,type,img );
		gl.pixelStorei( gl.UNPACK_PREMULTIPLY_ALPHA_WEBGL,false );	

		if( tex._genmipmap && tex._loading==1 ){
			gl.generateMipmap( target );
			tex._genmipmap=false;
		}
		gl.bindTexture( target,tmp );
		
		img.removeEventListener( "load",onload );
		tex._loading-=1;
		
		bb_texs_loading-=1;
	}
	
	img.addEventListener( "load",onload );
}

function _glTexImage2D3( target,level,internalformat,format,type,path ){

	var game=BBHtml5Game.Html5Game();

	var ty=game.GetMetaData( path,"type" );
	if( ty.indexOf( "image/" )!=0 ) return null;
	
	var img=new Image();
	img.src=game.PathToUrl( path );
	
	_glTexImage2D2( target,level,internalformat,format,type,img );
}

function _glTexSubImage2D( target,level,xoffset,yoffset,width,height,format,type,data,dataOffset ){

	gl.texSubImage2D( target,level,xoffset,yoffset,width,height,format,type,new Uint8Array( data.arrayBuffer,dataOffset ) );
	
}

function _glTexSubImage2D2( target,level,xoffset,yoffset,format,type,img ){

	if( img.complete ){
		gl.texSubImage2D( target,level,xoffset,yoffset,format,type,img );
		return;
	}
	
	var tex=gl.getParameter( gl.TEXTURE_BINDING_2D );
	if( 	tex._loading>0 ){
		tex._loading+=1;
	}else{
		tex._loading=1;
	}
	
	bb_texs_loading+=1;

	var onload=function(){
	
		var tmp=gl.getParameter( gl.TEXTURE_BINDING_2D );
		gl.bindTexture( target,tex );

		gl.pixelStorei( gl.UNPACK_PREMULTIPLY_ALPHA_WEBGL,true );	
		gl.texSubImage2D( target,level,xoffset,yoffset,format,type,img );
		gl.pixelStorei( gl.UNPACK_PREMULTIPLY_ALPHA_WEBGL,false );

		if( tex._genmipmap && tex._loading==1 ){
			gl.generateMipmap( target );
			tex._genmipmap=false;
		}
		gl.bindTexture( target,tmp );
		
		img.removeEventListener( "load",onload );
		tex._loading-=1;
		
		bb_texs_loading-=1;
	}
	
	img.addEventListener( "load",onload );
}

function _glTexSubImage2D3( target,level,xoffset,yoffset,format,type,path ){

	var game=BBHtml5Game.Html5Game();

	var ty=game.GetMetaData( path,"type" );
	if( ty.indexOf( "image/" )!=0 ) return null;
	
	var img=new Image();
	img.src=game.PathToUrl( path );
	
	_glTexSubImage2D2( target,level,xoffset,yoffset,format,type,img );
}

// Dodgy code to convert 'any' to i,f,iv,fv...
//
function _mkf( p ){
	if( typeof(p)=="boolean" ) return p?1.0:0.0;
	if( typeof(p)=="number" ) return p;
	return 0.0;
}

function _mki( p ){
	if( typeof(p)=="boolean" ) return p?1:0;
	if( typeof(p)=="number" ) return p|0;
	if( typeof(p)=="object" ) return p;
	return 0;
}

function _mkb( p ){
	if( typeof(p)=="boolean" ) return p;
	if( typeof(p)=="number" ) return p!=0;
	return false;
}

function _mkfv( p,params ){
	if( !params || !params.length ) return;
	if( (p instanceof Array) || (p instanceof Int32Array) || (p instanceof Float32Array) ){
		var n=Math.min( params.length,p.length );
		for( var i=0;i<n;++i ){
			params[i]=_mkf(p[i]);
		}
	}else{
		params[0]=_mkf(p);
	}
}

function _mkiv( p,params ){
	if( !params || !params.length ) return;
	if( (p instanceof Array) || (p instanceof Int32Array) || (p instanceof Float32Array) ){
		var n=Math.min( params.length,p.length );
		for( var i=0;i<n;++i ){
			params[i]=_mki(p[i]);
		}
	}else{
		params[0]=_mki(p);
	}
}

function _mkbv( p,params ){
	if( !params || !params.length ) return;
	if( (p instanceof Array) || (p instanceof Int32Array) || (p instanceof Float32Array) ){
		var n=Math.min( params.length,p.length );
		for( var i=0;i<n;++i ){
			params[i]=_mkb(p[i]);
		}
	}else{
		params[0]=_mkb(p);
	}
}

function _glBufferData( target,size,data,usage ){
	if( !data ){
		gl.bufferData( target,size,usage );
	}else if( size==data.size ){
		gl.bufferData( target,data.arrayBuffer,usage );
	}else{
		gl.bufferData( target,new Int8Array( data.arrayBuffer,0,size ),usage );
	}
}

function _glBufferSubData( target,offset,size,data,dataOffset ){
	if( size==data.size && dataOffset==0 ){
		gl.bufferSubData( target,offset,data.arrayBuffer );
	}else{
		gl.bufferSubData( target,offset,new Int8Array( data.arrayBuffer,dataOffset,size ) );
	}
}


function _glClearDepthf( depth ){
	gl.clearDepth( depth );
}

function _glDepthRange( zNear,zFar ){
	gl.depthRange( zNear,zFar );
}

function _glGetActiveAttrib( program,index,size,type,name ){
	var info=gl.getActiveAttrib( program,index );
	if( size && size.length ) size[0]=info.size;
	if( type && type.length ) type[0]=info.type;
	if( name && name.length ) name[0]=info.name;
}

function _glGetActiveUniform( program,index,size,type,name ){
	var info=gl.getActiveUniform( program,index );
	if( size && size.length ) size[0]=info.size;
	if( type && type.length ) type[0]=info.type;
	if( name && name.length ) name[0]=info.name;
}

function _glGetAttachedShaders( program, maxcount, count, shaders ){
	var t=gl.getAttachedShaders();
	if( count && count.length ) count[0]=t.length;
	if( shaders ){
		var n=t.length;
		if( maxcount<n ) n=maxcount;
		if( shaders.length<n ) n=shaders.length;
		for( var i=0;i<n;++i ) shaders[i]=t[i];
	}
}

function _glGetBooleanv( pname,params ){
	_mkbv( gl.getParameter( pname ),params );
}

function _glGetBufferParameteriv( target, pname, params ){
	_mkiv( gl.glGetBufferParameter( target,pname ),params );
}

function _glGetFloatv( pname,params ){
	_mkfv( gl.getParameter( pname ),params );
}

function _glGetFramebufferAttachmentParameteriv( target, attachment, pname, params ){
	_mkiv( gl.getFrameBufferAttachmentParameter( target,attachment,pname ),params );
}

function _glGetIntegerv( pname, params ){
	_mkiv( gl.getParameter( pname ),params );
}

function _glGetProgramiv( program, pname, params ){
	_mkiv( gl.getProgramParameter( program,pname ),params );
}

function _glGetRenderbufferParameteriv( target, pname, params ){
	_mkiv( gl.getRenderbufferParameter( target,pname ),params );
}

function _glGetShaderiv( shader, pname, params ){
	_mkiv( gl.getShaderParameter( shader,pname ),params );
}

function _glGetString( pname ){
	var p=gl.getParameter( pname );
	if( typeof(p)=="string" ) return p;
	return "";
}

function _glGetTexParameterfv( target, pname, params ){
	_mkfv( gl.getTexParameter( target,pname ),params );
}

function _glGetTexParameteriv( target, pname, params ){
	_mkiv( gl.getTexParameter( target,pname ),params );
}

function _glGetUniformfv( program, location, params ){
	_mkfv( gl.getUniform( program,location ),params );
}

function _glGetUniformiv( program, location, params ){
	_mkiv( gl.getUniform( program,location ),params );
}

function _glGetUniformLocation( program, name ){
	var l=gl.getUniformLocation( program,name );
	if( l ) return l;
	return -1;
}

function _glGetVertexAttribfv( index, pname, params ){
	_mkfv( gl.getVertexAttrib( index,pname ),params );
}

function _glGetVertexAttribiv( index, pname, params ){
	_mkiv( gl.getVertexAttrib( index,pname ),params );
}

function _glReadPixels( x,y,width,height,format,type,data,dataOffset ){
	gl.readPixels( x,y,width,height,format,type,new Uint8Array( data.arrayBuffer,dataOffset,data.length-dataOffset ) );
}

function _glBindBuffer( target,buffer ){
	if( buffer ){
		gl.bindBuffer( target,buffer );
	}else{
		gl.bindBuffer( target,null );
	}
}

function _glBindFramebuffer( target,framebuffer ){
	if( framebuffer ){
		gl.bindFramebuffer( target,framebuffer );
	}else{
		gl.bindFramebuffer( target,null );
	}
}

function _glBindRenderbuffer( target,renderbuffer ){
	if( renderbuffer ){
		gl.bindRenderbuffer( target,renderbuffer );
	}else{
		gl.bindRenderbuffer( target,null );
	}
}

function _glUniform1fv( location, count, v ){
	if( v.length==count ){
		gl.uniform1fv( location,v );
	}else{
		gl.uniform1fv( location,v.slice(0,cont) );
	}
}

function _glUniform1iv( location, count, v ){
	if( v.length==count ){
		gl.uniform1iv( location,v );
	}else{
		gl.uniform1iv( location,v.slice(0,cont) );
	}
}

function _glUniform2fv( location, count, v ){
	var n=count*2;
	if( v.length==n ){
		gl.uniform2fv( location,v );
	}else{
		gl.uniform2fv( location,v.slice(0,n) );
	}
}

function _glUniform2iv( location, count, v ){
	var n=count*2;
	if( v.length==n ){
		gl.uniform2iv( location,v );
	}else{
		gl.uniform2iv( location,v.slice(0,n) );
	}
}

function _glUniform3fv( location, count, v ){
	var n=count*3;
	if( v.length==n ){
		gl.uniform3fv( location,v );
	}else{
		gl.uniform3fv( location,v.slice(0,n) );
	}
}

function _glUniform3iv( location, count, v ){
	var n=count*3;
	if( v.length==n ){
		gl.uniform3iv( location,v );
	}else{
		gl.uniform3iv( location,v.slice(0,n) );
	}
}

function _glUniform4fv( location, count, v ){
	var n=count*4;
	if( v.length==n ){
		gl.uniform4fv( location,v );
	}else{
		gl.uniform4fv( location,v.slice(0,n) );
	}
}

function _glUniform4iv( location, count, v ){
	var n=count*4;
	if( v.length==n ){
		gl.uniform4iv( location,v );
	}else{
		gl.uniform4iv( location,v.slice(0,n) );
	}
}

function _glUniformMatrix2fv( location, count, transpose, value ){
	var n=count*4;
	if( value.length==n ){
		gl.uniformMatrix2fv( location,transpose,value );
	}else{
		gl.uniformMatrix2fv( location,transpose,value.slice(0,n) );
	}
}

function _glUniformMatrix3fv( location, count, transpose, value ){
	var n=count*9;
	if( value.length==n ){
		gl.uniformMatrix3fv( location,transpose,value );
	}else{
		gl.uniformMatrix3fv( location,transpose,value.slice(0,n) );
	}
}

function _glUniformMatrix4fv( location, count, transpose, value ){
	var n=count*16;
	if( value.length==n ){
		gl.uniformMatrix4fv( location,transpose,value );
	}else{
		gl.uniformMatrix4fv( location,transpose,value.slice(0,n) );
	}
}


function BBStream(){
}

BBStream.prototype.Eof=function(){
	return 0;
}

BBStream.prototype.Close=function(){
}

BBStream.prototype.Length=function(){
	return 0;
}

BBStream.prototype.Position=function(){
	return 0;
}

BBStream.prototype.Seek=function( position ){
	return 0;
}

BBStream.prototype.Read=function( buffer,offset,count ){
	return 0;
}

BBStream.prototype.Write=function( buffer,offset,count ){
	return 0;
}

function c_App(){
	Object.call(this);
}
c_App.m_new=function(){
	if((bb_app__app)!=null){
		error("App has already been created");
	}
	bb_app__app=this;
	bb_app__delegate=c_GameDelegate.m_new.call(new c_GameDelegate);
	bb_app__game.SetDelegate(bb_app__delegate);
	return this;
}
c_App.prototype.p_OnResize=function(){
	return 0;
}
c_App.prototype.p_OnCreate=function(){
	return 0;
}
c_App.prototype.p_OnSuspend=function(){
	return 0;
}
c_App.prototype.p_OnResume=function(){
	return 0;
}
c_App.prototype.p_OnUpdate=function(){
	return 0;
}
c_App.prototype.p_OnLoading=function(){
	return 0;
}
c_App.prototype.p_OnRender=function(){
	return 0;
}
c_App.prototype.p_OnClose=function(){
	bb_app_EndApp();
	return 0;
}
c_App.prototype.p_OnBack=function(){
	this.p_OnClose();
	return 0;
}
function c_TestApp(){
	c_App.call(this);
	this.m_mFont=null;
	this.m_mCam=null;
	this.m_mModel=null;
	this.m_mLights=new_object_array(2);
}
c_TestApp.prototype=extend_class(c_App);
c_TestApp.m_new=function(){
	c_App.m_new.call(this);
	return this;
}
c_TestApp.prototype.p_OnCreate=function(){
	bb_app_SetUpdateRate(0);
	bb_app_SetSwapInterval(0);
	bb_random_Seed=bb_app_Millisecs();
	if(!c_World.m_Init(8,75)){
		print("Error: "+c_Stats.m_ShaderError());
		bb_app_EndApp();
	}
	print("Vendor name: "+c_Stats.m_VendorName());
	print("Renderer name: "+c_Stats.m_RendererName());
	print("API version name: "+c_Stats.m_APIVersionName());
	print("Shading version name: "+c_Stats.m_ShadingVersionName());
	print("Shader compilation: "+c_Stats.m_ShaderError());
	this.m_mFont=c_Cache.m_LoadFont("system.fnt.dat");
	this.m_mCam=c_Camera.m_Create(null);
	this.m_mCam.p_SetPosition(16.0,16.0,-16.0);
	this.m_mCam.p_SetRotation2(20.0,-45.0,0.0);
	this.m_mCam.p_ClearColor2(c_Color.m_RGB(15,15,15,255));
	this.m_mModel=c_Model.m_Create(c_Cache.m_LoadMesh("robot.msh.dat","","",3),null);
	this.m_mLights[0]=c_Light.m_Create(1,null);
	this.m_mLights[0].p_SetPosition(32.0,0.0,32.0);
	this.m_mLights[0].p_Color(c_Color.m_RGB(125,161,191,255));
	this.m_mLights[1]=c_Light.m_Create(1,null);
	this.m_mLights[1].p_SetPosition(-32.0,32.0,-32.0);
	this.m_mLights[1].p_Color(c_Color.m_RGB(255,100,0,255));
	return 0;
}
c_TestApp.prototype.p_OnUpdate=function(){
	c_World.m_Update();
	this.m_mCam.p_AspectRatio2((bb_app_DeviceWidth())/(bb_app_DeviceHeight()));
	this.m_mCam.p_ViewportWidth2(bb_app_DeviceWidth());
	this.m_mCam.p_ViewportHeight2(bb_app_DeviceHeight());
	var t_=this.m_mModel;
	this.m_mModel.p_Yaw2(t_.p_Yaw()+32.0*c_Stats.m_DeltaTime());
	return 0;
}
c_TestApp.prototype.p_OnRender=function(){
	c_World.m_Render();
	c_Renderer.m_Setup2D(0,0,bb_app_DeviceWidth(),bb_app_DeviceHeight(),0);
	var t_text="Robo_OBJ_pose4 by Artem Shupa-Dubrova is licensed under CC Attribution-NoDerivs";
	c_Renderer.m_SetColor2(c_Color.m_RGB(240,240,240,255));
	this.m_mFont.p_Draw(((bb_app_DeviceWidth())-this.m_mFont.p_TextWidth(t_text))/2.0,8.0,t_text);
	return 0;
}
var bb_app__app=null;
function c_GameDelegate(){
	BBGameDelegate.call(this);
	this.m__graphics=null;
	this.m__audio=null;
	this.m__input=null;
}
c_GameDelegate.prototype=extend_class(BBGameDelegate);
c_GameDelegate.m_new=function(){
	return this;
}
c_GameDelegate.prototype.StartGame=function(){
	this.m__graphics=(new gxtkGraphics);
	bb_graphics_SetGraphicsDevice(this.m__graphics);
	bb_graphics_SetFont(null,32);
	this.m__audio=(new gxtkAudio);
	bb_audio_SetAudioDevice(this.m__audio);
	this.m__input=c_InputDevice.m_new.call(new c_InputDevice);
	bb_input_SetInputDevice(this.m__input);
	bb_app_ValidateDeviceWindow(false);
	bb_app_EnumDisplayModes();
	bb_app__app.p_OnCreate();
}
c_GameDelegate.prototype.SuspendGame=function(){
	bb_app__app.p_OnSuspend();
	this.m__audio.Suspend();
}
c_GameDelegate.prototype.ResumeGame=function(){
	this.m__audio.Resume();
	bb_app__app.p_OnResume();
}
c_GameDelegate.prototype.UpdateGame=function(){
	bb_app_ValidateDeviceWindow(true);
	this.m__input.p_BeginUpdate();
	bb_app__app.p_OnUpdate();
	this.m__input.p_EndUpdate();
}
c_GameDelegate.prototype.RenderGame=function(){
	bb_app_ValidateDeviceWindow(true);
	var t_mode=this.m__graphics.BeginRender();
	if((t_mode)!=0){
		bb_graphics_BeginRender();
	}
	if(t_mode==2){
		bb_app__app.p_OnLoading();
	}else{
		bb_app__app.p_OnRender();
	}
	if((t_mode)!=0){
		bb_graphics_EndRender();
	}
	this.m__graphics.EndRender();
}
c_GameDelegate.prototype.KeyEvent=function(t_event,t_data){
	this.m__input.p_KeyEvent(t_event,t_data);
	if(t_event!=1){
		return;
	}
	var t_1=t_data;
	if(t_1==432){
		bb_app__app.p_OnClose();
	}else{
		if(t_1==416){
			bb_app__app.p_OnBack();
		}
	}
}
c_GameDelegate.prototype.MouseEvent=function(t_event,t_data,t_x,t_y){
	this.m__input.p_MouseEvent(t_event,t_data,t_x,t_y);
}
c_GameDelegate.prototype.TouchEvent=function(t_event,t_data,t_x,t_y){
	this.m__input.p_TouchEvent(t_event,t_data,t_x,t_y);
}
c_GameDelegate.prototype.MotionEvent=function(t_event,t_data,t_x,t_y,t_z){
	this.m__input.p_MotionEvent(t_event,t_data,t_x,t_y,t_z);
}
c_GameDelegate.prototype.DiscardGraphics=function(){
	this.m__graphics.DiscardGraphics();
}
var bb_app__delegate=null;
var bb_app__game=null;
function bbMain(){
	c_TestApp.m_new.call(new c_TestApp);
	return 0;
}
var bb_graphics_device=null;
function bb_graphics_SetGraphicsDevice(t_dev){
	bb_graphics_device=t_dev;
	return 0;
}
function c_Image(){
	Object.call(this);
	this.m_surface=null;
	this.m_width=0;
	this.m_height=0;
	this.m_frames=[];
	this.m_flags=0;
	this.m_tx=.0;
	this.m_ty=.0;
	this.m_source=null;
}
c_Image.m_DefaultFlags=0;
c_Image.m_new=function(){
	return this;
}
c_Image.prototype.p_SetHandle=function(t_tx,t_ty){
	this.m_tx=t_tx;
	this.m_ty=t_ty;
	this.m_flags=this.m_flags&-2;
	return 0;
}
c_Image.prototype.p_ApplyFlags=function(t_iflags){
	this.m_flags=t_iflags;
	if((this.m_flags&2)!=0){
		var t_=this.m_frames;
		var t_2=0;
		while(t_2<t_.length){
			var t_f=t_[t_2];
			t_2=t_2+1;
			t_f.m_x+=1;
		}
		this.m_width-=2;
	}
	if((this.m_flags&4)!=0){
		var t_3=this.m_frames;
		var t_4=0;
		while(t_4<t_3.length){
			var t_f2=t_3[t_4];
			t_4=t_4+1;
			t_f2.m_y+=1;
		}
		this.m_height-=2;
	}
	if((this.m_flags&1)!=0){
		this.p_SetHandle((this.m_width)/2.0,(this.m_height)/2.0);
	}
	if(this.m_frames.length==1 && this.m_frames[0].m_x==0 && this.m_frames[0].m_y==0 && this.m_width==this.m_surface.Width() && this.m_height==this.m_surface.Height()){
		this.m_flags|=65536;
	}
	return 0;
}
c_Image.prototype.p_Init=function(t_surf,t_nframes,t_iflags){
	if((this.m_surface)!=null){
		error("Image already initialized");
	}
	this.m_surface=t_surf;
	this.m_width=((this.m_surface.Width()/t_nframes)|0);
	this.m_height=this.m_surface.Height();
	this.m_frames=new_object_array(t_nframes);
	for(var t_i=0;t_i<t_nframes;t_i=t_i+1){
		this.m_frames[t_i]=c_Frame.m_new.call(new c_Frame,t_i*this.m_width,0);
	}
	this.p_ApplyFlags(t_iflags);
	return this;
}
c_Image.prototype.p_Init2=function(t_surf,t_x,t_y,t_iwidth,t_iheight,t_nframes,t_iflags,t_src,t_srcx,t_srcy,t_srcw,t_srch){
	if((this.m_surface)!=null){
		error("Image already initialized");
	}
	this.m_surface=t_surf;
	this.m_source=t_src;
	this.m_width=t_iwidth;
	this.m_height=t_iheight;
	this.m_frames=new_object_array(t_nframes);
	var t_ix=t_x;
	var t_iy=t_y;
	for(var t_i=0;t_i<t_nframes;t_i=t_i+1){
		if(t_ix+this.m_width>t_srcw){
			t_ix=0;
			t_iy+=this.m_height;
		}
		if(t_ix+this.m_width>t_srcw || t_iy+this.m_height>t_srch){
			error("Image frame outside surface");
		}
		this.m_frames[t_i]=c_Frame.m_new.call(new c_Frame,t_ix+t_srcx,t_iy+t_srcy);
		t_ix+=this.m_width;
	}
	this.p_ApplyFlags(t_iflags);
	return this;
}
c_Image.prototype.p_Width=function(){
	return this.m_width;
}
c_Image.prototype.p_Height=function(){
	return this.m_height;
}
c_Image.prototype.p_Discard=function(){
	if(((this.m_surface)!=null) && !((this.m_source)!=null)){
		this.m_surface.Discard();
		this.m_surface=null;
	}
	return 0;
}
function c_GraphicsContext(){
	Object.call(this);
	this.m_defaultFont=null;
	this.m_font=null;
	this.m_firstChar=0;
	this.m_matrixSp=0;
	this.m_ix=1.0;
	this.m_iy=.0;
	this.m_jx=.0;
	this.m_jy=1.0;
	this.m_tx=.0;
	this.m_ty=.0;
	this.m_tformed=0;
	this.m_matDirty=0;
	this.m_color_r=.0;
	this.m_color_g=.0;
	this.m_color_b=.0;
	this.m_alpha=.0;
	this.m_blend=0;
	this.m_scissor_x=.0;
	this.m_scissor_y=.0;
	this.m_scissor_width=.0;
	this.m_scissor_height=.0;
}
c_GraphicsContext.m_new=function(){
	return this;
}
var bb_graphics_context=null;
function bb_data_FixDataPath(t_path){
	var t_i=t_path.indexOf(":/",0);
	if(t_i!=-1 && t_path.indexOf("/",0)==t_i+1){
		return t_path;
	}
	if(string_startswith(t_path,"./") || string_startswith(t_path,"/")){
		return t_path;
	}
	return "cerberus://data/"+t_path;
}
function c_Frame(){
	Object.call(this);
	this.m_x=0;
	this.m_y=0;
}
c_Frame.m_new=function(t_x,t_y){
	this.m_x=t_x;
	this.m_y=t_y;
	return this;
}
c_Frame.m_new2=function(){
	return this;
}
function bb_graphics_LoadImage(t_path,t_frameCount,t_flags){
	var t_surf=bb_graphics_device.LoadSurface(bb_data_FixDataPath(t_path));
	if((t_surf)!=null){
		return (c_Image.m_new.call(new c_Image)).p_Init(t_surf,t_frameCount,t_flags);
	}
	return null;
}
function bb_graphics_LoadImage2(t_path,t_frameWidth,t_frameHeight,t_frameCount,t_flags){
	var t_surf=bb_graphics_device.LoadSurface(bb_data_FixDataPath(t_path));
	if((t_surf)!=null){
		return (c_Image.m_new.call(new c_Image)).p_Init2(t_surf,0,0,t_frameWidth,t_frameHeight,t_frameCount,t_flags,null,0,0,t_surf.Width(),t_surf.Height());
	}
	return null;
}
function bb_graphics_SetFont(t_font,t_firstChar){
	if(!((t_font)!=null)){
		if(!((bb_graphics_context.m_defaultFont)!=null)){
			bb_graphics_context.m_defaultFont=bb_graphics_LoadImage("mojo_font.png",96,2);
		}
		t_font=bb_graphics_context.m_defaultFont;
		t_firstChar=32;
	}
	bb_graphics_context.m_font=t_font;
	bb_graphics_context.m_firstChar=t_firstChar;
	return 0;
}
var bb_audio_device=null;
function bb_audio_SetAudioDevice(t_dev){
	bb_audio_device=t_dev;
	return 0;
}
function c_InputDevice(){
	Object.call(this);
	this.m__joyStates=new_object_array(4);
	this.m__keyDown=new_bool_array(512);
	this.m__keyHitPut=0;
	this.m__keyHitQueue=new_number_array(33);
	this.m__keyHit=new_number_array(512);
	this.m__charGet=0;
	this.m__charPut=0;
	this.m__charQueue=new_number_array(32);
	this.m__mouseX=.0;
	this.m__mouseY=.0;
	this.m__touchX=new_number_array(32);
	this.m__touchY=new_number_array(32);
	this.m__accelX=.0;
	this.m__accelY=.0;
	this.m__accelZ=.0;
}
c_InputDevice.m_new=function(){
	for(var t_i=0;t_i<4;t_i=t_i+1){
		this.m__joyStates[t_i]=c_JoyState.m_new.call(new c_JoyState);
	}
	return this;
}
c_InputDevice.prototype.p_PutKeyHit=function(t_key){
	if(this.m__keyHitPut==this.m__keyHitQueue.length){
		return;
	}
	this.m__keyHit[t_key]+=1;
	this.m__keyHitQueue[this.m__keyHitPut]=t_key;
	this.m__keyHitPut+=1;
}
c_InputDevice.prototype.p_BeginUpdate=function(){
	for(var t_i=0;t_i<4;t_i=t_i+1){
		var t_state=this.m__joyStates[t_i];
		if(!BBGame.Game().PollJoystick(t_i,t_state.m_joyx,t_state.m_joyy,t_state.m_joyz,t_state.m_buttons)){
			break;
		}
		for(var t_j=0;t_j<32;t_j=t_j+1){
			var t_key=256+t_i*32+t_j;
			if(t_state.m_buttons[t_j]){
				if(!this.m__keyDown[t_key]){
					this.m__keyDown[t_key]=true;
					this.p_PutKeyHit(t_key);
				}
			}else{
				this.m__keyDown[t_key]=false;
			}
		}
	}
}
c_InputDevice.prototype.p_EndUpdate=function(){
	for(var t_i=0;t_i<this.m__keyHitPut;t_i=t_i+1){
		this.m__keyHit[this.m__keyHitQueue[t_i]]=0;
	}
	this.m__keyHitPut=0;
	this.m__charGet=0;
	this.m__charPut=0;
}
c_InputDevice.prototype.p_KeyEvent=function(t_event,t_data){
	var t_1=t_event;
	if(t_1==1){
		if(!this.m__keyDown[t_data]){
			this.m__keyDown[t_data]=true;
			this.p_PutKeyHit(t_data);
			if(t_data==1){
				this.m__keyDown[384]=true;
				this.p_PutKeyHit(384);
			}else{
				if(t_data==384){
					this.m__keyDown[1]=true;
					this.p_PutKeyHit(1);
				}
			}
		}
	}else{
		if(t_1==2){
			if(this.m__keyDown[t_data]){
				this.m__keyDown[t_data]=false;
				if(t_data==1){
					this.m__keyDown[384]=false;
				}else{
					if(t_data==384){
						this.m__keyDown[1]=false;
					}
				}
			}
		}else{
			if(t_1==3){
				if(this.m__charPut<this.m__charQueue.length){
					this.m__charQueue[this.m__charPut]=t_data;
					this.m__charPut+=1;
				}
			}
		}
	}
}
c_InputDevice.prototype.p_MouseEvent=function(t_event,t_data,t_x,t_y){
	var t_2=t_event;
	if(t_2==4){
		this.p_KeyEvent(1,1+t_data);
	}else{
		if(t_2==5){
			this.p_KeyEvent(2,1+t_data);
			return;
		}else{
			if(t_2==6){
			}else{
				return;
			}
		}
	}
	this.m__mouseX=t_x;
	this.m__mouseY=t_y;
	this.m__touchX[0]=t_x;
	this.m__touchY[0]=t_y;
}
c_InputDevice.prototype.p_TouchEvent=function(t_event,t_data,t_x,t_y){
	var t_3=t_event;
	if(t_3==7){
		this.p_KeyEvent(1,384+t_data);
	}else{
		if(t_3==8){
			this.p_KeyEvent(2,384+t_data);
			return;
		}else{
			if(t_3==9){
			}else{
				return;
			}
		}
	}
	this.m__touchX[t_data]=t_x;
	this.m__touchY[t_data]=t_y;
	if(t_data==0){
		this.m__mouseX=t_x;
		this.m__mouseY=t_y;
	}
}
c_InputDevice.prototype.p_MotionEvent=function(t_event,t_data,t_x,t_y,t_z){
	var t_4=t_event;
	if(t_4==10){
	}else{
		return;
	}
	this.m__accelX=t_x;
	this.m__accelY=t_y;
	this.m__accelZ=t_z;
}
function c_JoyState(){
	Object.call(this);
	this.m_joyx=new_number_array(2);
	this.m_joyy=new_number_array(2);
	this.m_joyz=new_number_array(2);
	this.m_buttons=new_bool_array(32);
}
c_JoyState.m_new=function(){
	return this;
}
var bb_input_device=null;
function bb_input_SetInputDevice(t_dev){
	bb_input_device=t_dev;
	return 0;
}
var bb_app__devWidth=0;
var bb_app__devHeight=0;
function bb_app_ValidateDeviceWindow(t_notifyApp){
	var t_w=bb_app__game.GetDeviceWidth();
	var t_h=bb_app__game.GetDeviceHeight();
	if(t_w==bb_app__devWidth && t_h==bb_app__devHeight){
		return;
	}
	bb_app__devWidth=t_w;
	bb_app__devHeight=t_h;
	if(t_notifyApp){
		bb_app__app.p_OnResize();
	}
}
function c_DisplayMode(){
	Object.call(this);
	this.m__width=0;
	this.m__height=0;
}
c_DisplayMode.m_new=function(t_width,t_height){
	this.m__width=t_width;
	this.m__height=t_height;
	return this;
}
c_DisplayMode.m_new2=function(){
	return this;
}
function c_Map(){
	Object.call(this);
	this.m_root=null;
}
c_Map.m_new=function(){
	return this;
}
c_Map.prototype.p_Compare=function(t_lhs,t_rhs){
}
c_Map.prototype.p_FindNode=function(t_key){
	var t_node=this.m_root;
	while((t_node)!=null){
		var t_cmp=this.p_Compare(t_key,t_node.m_key);
		if(t_cmp>0){
			t_node=t_node.m_right;
		}else{
			if(t_cmp<0){
				t_node=t_node.m_left;
			}else{
				return t_node;
			}
		}
	}
	return t_node;
}
c_Map.prototype.p_Contains=function(t_key){
	return this.p_FindNode(t_key)!=null;
}
c_Map.prototype.p_RotateLeft=function(t_node){
	var t_child=t_node.m_right;
	t_node.m_right=t_child.m_left;
	if((t_child.m_left)!=null){
		t_child.m_left.m_parent=t_node;
	}
	t_child.m_parent=t_node.m_parent;
	if((t_node.m_parent)!=null){
		if(t_node==t_node.m_parent.m_left){
			t_node.m_parent.m_left=t_child;
		}else{
			t_node.m_parent.m_right=t_child;
		}
	}else{
		this.m_root=t_child;
	}
	t_child.m_left=t_node;
	t_node.m_parent=t_child;
	return 0;
}
c_Map.prototype.p_RotateRight=function(t_node){
	var t_child=t_node.m_left;
	t_node.m_left=t_child.m_right;
	if((t_child.m_right)!=null){
		t_child.m_right.m_parent=t_node;
	}
	t_child.m_parent=t_node.m_parent;
	if((t_node.m_parent)!=null){
		if(t_node==t_node.m_parent.m_right){
			t_node.m_parent.m_right=t_child;
		}else{
			t_node.m_parent.m_left=t_child;
		}
	}else{
		this.m_root=t_child;
	}
	t_child.m_right=t_node;
	t_node.m_parent=t_child;
	return 0;
}
c_Map.prototype.p_InsertFixup=function(t_node){
	while(((t_node.m_parent)!=null) && t_node.m_parent.m_color==-1 && ((t_node.m_parent.m_parent)!=null)){
		if(t_node.m_parent==t_node.m_parent.m_parent.m_left){
			var t_uncle=t_node.m_parent.m_parent.m_right;
			if(((t_uncle)!=null) && t_uncle.m_color==-1){
				t_node.m_parent.m_color=1;
				t_uncle.m_color=1;
				t_uncle.m_parent.m_color=-1;
				t_node=t_uncle.m_parent;
			}else{
				if(t_node==t_node.m_parent.m_right){
					t_node=t_node.m_parent;
					this.p_RotateLeft(t_node);
				}
				t_node.m_parent.m_color=1;
				t_node.m_parent.m_parent.m_color=-1;
				this.p_RotateRight(t_node.m_parent.m_parent);
			}
		}else{
			var t_uncle2=t_node.m_parent.m_parent.m_left;
			if(((t_uncle2)!=null) && t_uncle2.m_color==-1){
				t_node.m_parent.m_color=1;
				t_uncle2.m_color=1;
				t_uncle2.m_parent.m_color=-1;
				t_node=t_uncle2.m_parent;
			}else{
				if(t_node==t_node.m_parent.m_left){
					t_node=t_node.m_parent;
					this.p_RotateRight(t_node);
				}
				t_node.m_parent.m_color=1;
				t_node.m_parent.m_parent.m_color=-1;
				this.p_RotateLeft(t_node.m_parent.m_parent);
			}
		}
	}
	this.m_root.m_color=1;
	return 0;
}
c_Map.prototype.p_Set=function(t_key,t_value){
	var t_node=this.m_root;
	var t_parent=null;
	var t_cmp=0;
	while((t_node)!=null){
		t_parent=t_node;
		t_cmp=this.p_Compare(t_key,t_node.m_key);
		if(t_cmp>0){
			t_node=t_node.m_right;
		}else{
			if(t_cmp<0){
				t_node=t_node.m_left;
			}else{
				t_node.m_value=t_value;
				return false;
			}
		}
	}
	t_node=c_Node.m_new.call(new c_Node,t_key,t_value,-1,t_parent);
	if((t_parent)!=null){
		if(t_cmp>0){
			t_parent.m_right=t_node;
		}else{
			t_parent.m_left=t_node;
		}
		this.p_InsertFixup(t_node);
	}else{
		this.m_root=t_node;
	}
	return true;
}
c_Map.prototype.p_Insert=function(t_key,t_value){
	return this.p_Set(t_key,t_value);
}
function c_IntMap(){
	c_Map.call(this);
}
c_IntMap.prototype=extend_class(c_Map);
c_IntMap.m_new=function(){
	c_Map.m_new.call(this);
	return this;
}
c_IntMap.prototype.p_Compare=function(t_lhs,t_rhs){
	return t_lhs-t_rhs;
}
function c_Stack(){
	Object.call(this);
	this.m_data=[];
	this.m_length=0;
}
c_Stack.m_new=function(){
	return this;
}
c_Stack.m_new2=function(t_data){
	this.m_data=t_data.slice(0);
	this.m_length=t_data.length;
	return this;
}
c_Stack.prototype.p_Push=function(t_value){
	if(this.m_length==this.m_data.length){
		this.m_data=resize_object_array(this.m_data,this.m_length*2+10);
	}
	this.m_data[this.m_length]=t_value;
	this.m_length+=1;
}
c_Stack.prototype.p_Push2=function(t_values,t_offset,t_count){
	for(var t_i=0;t_i<t_count;t_i=t_i+1){
		this.p_Push(t_values[t_offset+t_i]);
	}
}
c_Stack.prototype.p_Push3=function(t_values,t_offset){
	this.p_Push2(t_values,t_offset,t_values.length-t_offset);
}
c_Stack.prototype.p_ToArray=function(){
	var t_t=new_object_array(this.m_length);
	for(var t_i=0;t_i<this.m_length;t_i=t_i+1){
		t_t[t_i]=this.m_data[t_i];
	}
	return t_t;
}
function c_Node(){
	Object.call(this);
	this.m_key=0;
	this.m_right=null;
	this.m_left=null;
	this.m_value=null;
	this.m_color=0;
	this.m_parent=null;
}
c_Node.m_new=function(t_key,t_value,t_color,t_parent){
	this.m_key=t_key;
	this.m_value=t_value;
	this.m_color=t_color;
	this.m_parent=t_parent;
	return this;
}
c_Node.m_new2=function(){
	return this;
}
var bb_app__displayModes=[];
var bb_app__desktopMode=null;
function bb_app_DeviceWidth(){
	return bb_app__devWidth;
}
function bb_app_DeviceHeight(){
	return bb_app__devHeight;
}
function bb_app_EnumDisplayModes(){
	var t_modes=bb_app__game.GetDisplayModes();
	var t_mmap=c_IntMap.m_new.call(new c_IntMap);
	var t_mstack=c_Stack.m_new.call(new c_Stack);
	for(var t_i=0;t_i<t_modes.length;t_i=t_i+1){
		var t_w=t_modes[t_i].width;
		var t_h=t_modes[t_i].height;
		var t_size=t_w<<16|t_h;
		if(t_mmap.p_Contains(t_size)){
		}else{
			var t_mode=c_DisplayMode.m_new.call(new c_DisplayMode,t_modes[t_i].width,t_modes[t_i].height);
			t_mmap.p_Insert(t_size,t_mode);
			t_mstack.p_Push(t_mode);
		}
	}
	bb_app__displayModes=t_mstack.p_ToArray();
	var t_mode2=bb_app__game.GetDesktopMode();
	if((t_mode2)!=null){
		bb_app__desktopMode=c_DisplayMode.m_new.call(new c_DisplayMode,t_mode2.width,t_mode2.height);
	}else{
		bb_app__desktopMode=c_DisplayMode.m_new.call(new c_DisplayMode,bb_app_DeviceWidth(),bb_app_DeviceHeight());
	}
}
var bb_graphics_renderDevice=null;
function bb_graphics_SetMatrix(t_ix,t_iy,t_jx,t_jy,t_tx,t_ty){
	bb_graphics_context.m_ix=t_ix;
	bb_graphics_context.m_iy=t_iy;
	bb_graphics_context.m_jx=t_jx;
	bb_graphics_context.m_jy=t_jy;
	bb_graphics_context.m_tx=t_tx;
	bb_graphics_context.m_ty=t_ty;
	bb_graphics_context.m_tformed=((t_ix!=1.0 || t_iy!=0.0 || t_jx!=0.0 || t_jy!=1.0 || t_tx!=0.0 || t_ty!=0.0)?1:0);
	bb_graphics_context.m_matDirty=1;
	return 0;
}
function bb_graphics_SetMatrix2(t_m){
	bb_graphics_SetMatrix(t_m[0],t_m[1],t_m[2],t_m[3],t_m[4],t_m[5]);
	return 0;
}
function bb_graphics_SetColor(t_r,t_g,t_b){
	bb_graphics_context.m_color_r=t_r;
	bb_graphics_context.m_color_g=t_g;
	bb_graphics_context.m_color_b=t_b;
	bb_graphics_renderDevice.SetColor(t_r,t_g,t_b);
	return 0;
}
function bb_graphics_SetAlpha(t_alpha){
	bb_graphics_context.m_alpha=t_alpha;
	bb_graphics_renderDevice.SetAlpha(t_alpha);
	return 0;
}
function bb_graphics_SetBlend(t_blend){
	bb_graphics_context.m_blend=t_blend;
	bb_graphics_renderDevice.SetBlend(t_blend);
	return 0;
}
function bb_graphics_SetScissor(t_x,t_y,t_width,t_height){
	bb_graphics_context.m_scissor_x=t_x;
	bb_graphics_context.m_scissor_y=t_y;
	bb_graphics_context.m_scissor_width=t_width;
	bb_graphics_context.m_scissor_height=t_height;
	bb_graphics_renderDevice.SetScissor(((t_x)|0),((t_y)|0),((t_width)|0),((t_height)|0));
	return 0;
}
function bb_graphics_BeginRender(){
	bb_graphics_renderDevice=bb_graphics_device;
	bb_graphics_context.m_matrixSp=0;
	bb_graphics_SetMatrix(1.0,0.0,0.0,1.0,0.0,0.0);
	bb_graphics_SetColor(255.0,255.0,255.0);
	bb_graphics_SetAlpha(1.0);
	bb_graphics_SetBlend(0);
	bb_graphics_SetScissor(0.0,0.0,(bb_app_DeviceWidth()),(bb_app_DeviceHeight()));
	return 0;
}
function bb_graphics_EndRender(){
	bb_graphics_renderDevice=null;
	return 0;
}
function c_BBGameEvent(){
	Object.call(this);
}
function bb_app_EndApp(){
	error("");
}
var bb_app__updateRate=0;
function bb_app_SetUpdateRate(t_hertz){
	bb_app__updateRate=t_hertz;
	bb_app__game.SetUpdateRate(t_hertz);
}
function bb_app_SetSwapInterval(t_interval){
	bb_app__game.SetSwapInterval(t_interval);
}
function bb_app_Millisecs(){
	return bb_app__game.Millisecs();
}
var bb_random_Seed=0;
function c_World(){
	Object.call(this);
}
c_World.m_mSkybox=null;
c_World.m_mAmbient=0;
c_World.m_SetAmbient=function(t_amb){
	c_World.m_mAmbient=t_amb;
}
c_World.m_mFogEnabled=false;
c_World.m_SetFogEnabled=function(t_enabled){
	c_World.m_mFogEnabled=t_enabled;
}
c_World.m_mFogMin=0;
c_World.m_SetFogMinDistance=function(t_minDist){
	c_World.m_mFogMin=t_minDist;
}
c_World.m_mFogMax=0;
c_World.m_SetFogMaxDistance=function(t_maxDist){
	c_World.m_mFogMax=t_maxDist;
}
c_World.m_mFogColor=0;
c_World.m_SetFogColor=function(t_color){
	c_World.m_mFogColor=t_color;
}
c_World.m_mGlobalPixelLighting=false;
c_World.m_SetGlobalPixelLighting=function(t_enable){
	c_World.m_mGlobalPixelLighting=t_enable;
}
c_World.m_mShadowsEnabled=false;
c_World.m_mDepthHeight=0;
c_World.m_mDepthFar=0;
c_World.m_mDepthEpsilon=0;
c_World.m_SetShadows=function(t_enable,t_depthHeight,t_depthFar,t_depthEpsilon){
	c_World.m_mShadowsEnabled=t_enable;
	c_World.m_mDepthHeight=t_depthHeight;
	c_World.m_mDepthFar=t_depthFar;
	c_World.m_mDepthEpsilon=t_depthEpsilon;
}
c_World.m_mFramebuffer=null;
c_World.m_Init=function(t_numLights,t_numBones){
	if(c_Renderer.m_Init(t_numLights,t_numBones)){
		c_Cache.m_Push();
		c_Stats.m__Init();
		c_World.m_mSkybox=c_Primitive.m_CreateSkybox();
		c_World.m_mSkybox.p_Surface(0).p_Material().p_DepthWrite2(false);
		c_World.m_SetAmbient(c_Color.m_RGB(75,75,75,255));
		c_World.m_SetFogEnabled(false);
		c_World.m_SetFogMinDistance(600.0);
		c_World.m_SetFogMaxDistance(1000.0);
		c_World.m_SetFogColor(-16777216);
		c_World.m_SetGlobalPixelLighting(false);
		c_World.m_SetShadows(false,500.0,1000.0,0.009);
		c_World.m_mFramebuffer=c_Framebuffer.m_Create(1024,1024,true);
		return true;
	}else{
		return false;
	}
}
c_World.m_mEntities=null;
c_World.m__AddEntity=function(t_e){
	c_World.m_mEntities.p_AddLast3(t_e);
}
c_World.m_mCameras=null;
c_World.m__AddCamera=function(t_c){
	c_World.m_mCameras.p_AddLast4(t_c);
}
c_World.m__FreeCamera=function(t_c){
	c_World.m_mCameras.p_RemoveFirst4(t_c);
}
c_World.m_mRenderList=null;
c_World.m__AddSurfaceToRenderList=function(t_surface,t_transform,t_overrideMaterial){
	c_World.m_mRenderList.p_AddSurface2(t_surface,t_transform,t_overrideMaterial);
}
c_World.m__AddSurfaceToRenderList2=function(t_surface,t_transform,t_animMatrices,t_overrideMaterial){
	if(t_animMatrices.length>0){
		c_World.m_mRenderList.p_AddSurface3(t_surface,t_transform,t_animMatrices,t_overrideMaterial);
	}else{
		c_World.m_mRenderList.p_AddSurface2(t_surface,t_transform,t_overrideMaterial);
	}
}
c_World.m__RemoveSurfaceFromRenderList=function(t_surface,t_transform,t_overrideMaterial){
	c_World.m_mRenderList.p_RemoveSurface(t_surface,t_transform,t_overrideMaterial);
}
c_World.m__RemoveSurfaceFromRenderList2=function(t_surface,t_transform,t_animMatrices,t_overrideMaterial){
	if(t_animMatrices.length>0){
		c_World.m_mRenderList.p_RemoveSurface2(t_surface,t_transform,t_animMatrices,t_overrideMaterial);
	}else{
		c_World.m_mRenderList.p_RemoveSurface(t_surface,t_transform,t_overrideMaterial);
	}
}
c_World.m_mEnabledEntities=null;
c_World.m__EntityNeedsUpdate=function(t_e,t_update){
	if(t_update){
		if(!c_World.m_mEnabledEntities.p_Contains3(t_e)){
			c_World.m_mEnabledEntities.p_AddLast3(t_e);
		}
	}else{
		c_World.m_mEnabledEntities.p_RemoveFirst3(t_e);
	}
}
c_World.m_mLights=null;
c_World.m__AddLight=function(t_l){
	c_World.m_mLights.p_AddLast7(t_l);
}
c_World.m__FreeLight=function(t_l){
	c_World.m_mLights.p_RemoveFirst6(t_l);
}
c_World.m_Update=function(){
	c_Stats.m__UpdateDeltaTime();
	var t_=c_World.m_mEnabledEntities.p_ObjectEnumerator();
	while(t_.p_HasNext()){
		var t_e=t_.p_NextObject();
		t_e.p__Update();
	}
	c_Listener.m__Update();
}
c_World.m_mTempQuat=null;
c_World.m_mDepthProj=null;
c_World.m_mDepthView=null;
c_World.m_mSkyboxMatrix=null;
c_World.m__DrawSkybox=function(t_x,t_y,t_z){
	c_World.m_mSkyboxMatrix.p_SetTransform2(t_x,t_y,t_z,0.0,0.0,0.0,10.0,10.0,10.0);
	c_Renderer.m_SetModelMatrix(c_World.m_mSkyboxMatrix);
	c_World.m_mSkybox.p_Surface(0).p_Material().p_Prepare();
	c_World.m_mSkybox.p_Surface(0).p_Draw3();
}
c_World.m_DepthTexture=function(){
	return c_World.m_mFramebuffer.p_ColorTexture();
}
c_World.m_GlobalPixelLighting=function(){
	return c_World.m_mGlobalPixelLighting;
}
c_World.m_mVisibleEntities=null;
c_World.m_Render=function(){
	c_Stats.m__UpdateFPS();
	c_Stats.m__SetRenderCalls(0);
	var t_numLights=c_World.m_mLights.p_Count();
	var t_=c_World.m_mCameras.p_ObjectEnumerator();
	while(t_.p_HasNext()){
		var t_c=t_.p_NextObject();
		if(c_World.m_mShadowsEnabled && t_numLights>0){
			var t_dirLight=c_World.m_mLights.p_First();
			c_World.m_mTempQuat.p_SetEuler(t_dirLight.p_Pitch(),t_dirLight.p_Yaw(),t_dirLight.p_Roll());
			c_World.m_mTempQuat.p_Mul8(0.0,0.0,-c_World.m_mDepthFar/2.0);
			c_World.m_mDepthProj.p_SetOrthoLH2(c_World.m_mDepthHeight,t_c.p_AspectRatio(),0.0,c_World.m_mDepthFar);
			c_World.m_mDepthView.p_LookAtLH(c_Quat.m_ResultVector().m_X,c_Quat.m_ResultVector().m_Y,c_Quat.m_ResultVector().m_Z,0.0,0.0,0.0,0.0,1.0,0.0);
			c_World.m_mFramebuffer.p_Set13();
			c_Renderer.m_Setup3D(0,0,c_World.m_mFramebuffer.p_ColorTexture().p_Width(),c_World.m_mFramebuffer.p_ColorTexture().p_Height(),true,c_World.m_mFramebuffer.p_ColorTexture().p_Height());
			c_Renderer.m_SetProjectionMatrix(c_World.m_mDepthProj);
			c_Renderer.m_SetViewMatrix(c_World.m_mDepthView);
			c_Renderer.m_ClearColorBuffer(-1);
			c_Renderer.m_ClearDepthBuffer();
			c_Stats.m__SetRenderCalls(c_Stats.m_RenderCalls()+c_World.m_mRenderList.p_Render());
			c_Framebuffer.m_SetScreen();
		}
		t_c.p__PrepareForRender();
		c_Renderer.m_SetFog(c_World.m_mFogEnabled,c_World.m_mFogMin,c_World.m_mFogMax,(c_Color.m_Red(c_World.m_mFogColor))/255.0,(c_Color.m_Green(c_World.m_mFogColor))/255.0,(c_Color.m_Blue(c_World.m_mFogColor))/255.0);
		c_Renderer.m_SetNumLights(t_numLights);
		if(c_World.m_mShadowsEnabled && t_numLights>0){
			c_Renderer.m_SetDepthData(c_World.m_mDepthProj,c_World.m_mDepthView,c_World.m_DepthTexture().p_Handle(),c_World.m_mDepthEpsilon);
		}else{
			c_Renderer.m_SetDepthData(c_World.m_mDepthProj,c_World.m_mDepthView,0,c_World.m_mDepthEpsilon);
		}
		if(t_numLights>0){
			c_Renderer.m_SetPixelLighting(c_World.m_GlobalPixelLighting());
			c_Renderer.m_SetAmbient((c_Color.m_Red(c_World.m_mAmbient))/255.0,(c_Color.m_Green(c_World.m_mAmbient))/255.0,(c_Color.m_Blue(c_World.m_mAmbient))/255.0);
			var t_i=0;
			var t_2=c_World.m_mLights.p_ObjectEnumerator();
			while(t_2.p_HasNext()){
				var t_l=t_2.p_NextObject();
				t_l.p__Number2(t_i);
				t_l.p__PrepareForRender();
				t_i+=1;
			}
		}
		var t_3=c_World.m_mVisibleEntities.p_ObjectEnumerator();
		while(t_3.p_HasNext()){
			var t_e=t_3.p_NextObject();
			t_e.p__PrepareForRender();
		}
		c_Stats.m__SetRenderCalls(c_Stats.m_RenderCalls()+c_World.m_mRenderList.p_Render());
	}
}
function c_Renderer(){
	Object.call(this);
}
c_Renderer.m_mMaxLights=0;
c_Renderer.m_mMaxBones=0;
c_Renderer.m_mVendor="";
c_Renderer.m_mRenderer="";
c_Renderer.m_mVersionStr="";
c_Renderer.m_mShadingVersionStr="";
c_Renderer.m_mVersion=0;
c_Renderer.m_mShadingVersion=0;
c_Renderer.m_mProgramError="";
c_Renderer.m_FreeProgram=function(t_program){
	t_program.p_Free();
}
c_Renderer.m_CreateProgram=function(t_vertex,t_fragment){
	t_vertex="#define MAX_LIGHTS "+String(c_Renderer.m_mMaxLights)+"\n#define MAX_BONES "+String(c_Renderer.m_mMaxBones)+"\n"+t_vertex;
	t_fragment="#define MAX_LIGHTS "+String(c_Renderer.m_mMaxLights)+"\n"+t_fragment;
	var t_retCode=new_number_array(1);
	var t_vshader=gl.createShader(35633);
	gl.shaderSource(t_vshader,t_vertex);
	gl.compileShader(t_vshader);
	c_Renderer.m_mProgramError=gl.getShaderInfoLog(t_vshader);
	_glGetShaderiv(t_vshader,35713,t_retCode);
	if(t_retCode[0]==0){
		gl.deleteShader(t_vshader);
		return null;
	}
	var t_fshader=gl.createShader(35632);
	gl.shaderSource(t_fshader,t_fragment);
	gl.compileShader(t_fshader);
	c_Renderer.m_mProgramError=c_Renderer.m_mProgramError+("\n"+gl.getShaderInfoLog(t_fshader));
	_glGetShaderiv(t_fshader,35713,t_retCode);
	if(t_retCode[0]==0){
		gl.deleteShader(t_vshader);
		gl.deleteShader(t_fshader);
		return null;
	}
	var t_program=gl.createProgram();
	gl.attachShader(t_program,t_vshader);
	gl.attachShader(t_program,t_fshader);
	gl.linkProgram(t_program);
	gl.deleteShader(t_vshader);
	gl.deleteShader(t_fshader);
	_glGetProgramiv(t_program,35714,t_retCode);
	if(t_retCode[0]==0){
		c_Renderer.m_mProgramError=gl.getProgramInfoLog(t_program);
		c_Renderer.m_FreeProgram(c_GpuProgram.m_new.call(new c_GpuProgram,t_program));
		return null;
	}
	return c_GpuProgram.m_new.call(new c_GpuProgram,t_program);
}
c_Renderer.m_mDefaultProgram=null;
c_Renderer.m_mDepthProgram=null;
c_Renderer.m_m2DProgram=null;
c_Renderer.m_mActiveProgram=null;
c_Renderer.m_UseProgram=function(t_program){
	if(t_program==null){
		t_program=c_Renderer.m_mDefaultProgram;
	}
	t_program.p_Use();
	c_Renderer.m_mActiveProgram=t_program;
}
c_Renderer.m_mEllipseBuffer=0;
c_Renderer.m_FreeBuffer=function(t_buffer){
	gl.deleteBuffer(t_buffer);
}
c_Renderer.m_mLineBuffer=0;
c_Renderer.m_mRectBuffer=0;
c_Renderer.m_ResizeVertexBuffer=function(t_buffer,t_size){
	_glBindBuffer(34962,t_buffer);
	_glBufferData(34962,t_size,null,35044);
	_glBindBuffer(34962,0);
}
c_Renderer.m_CreateVertexBuffer=function(t_size){
	var t_buffer=gl.createBuffer();
	if(t_size>0){
		c_Renderer.m_ResizeVertexBuffer(t_buffer,t_size);
	}
	return t_buffer;
}
c_Renderer.m_SetVertexBufferData=function(t_buffer,t_offset,t_size,t_data){
	_glBindBuffer(34962,t_buffer);
	_glBufferSubData(34962,t_offset,t_size,t_data,0);
	_glBindBuffer(34962,0);
}
c_Renderer.m_Init=function(t_numLights,t_numBones){
	c_Renderer.m_mMaxLights=t_numLights;
	c_Renderer.m_mMaxBones=t_numBones;
	c_Renderer.m_mVendor=_glGetString(7936);
	c_Renderer.m_mRenderer=_glGetString(7937);
	c_Renderer.m_mVersionStr=_glGetString(7938);
	c_Renderer.m_mShadingVersionStr=_glGetString(35724);
	var t_glVersionStr=c_Renderer.m_mVersionStr.split(" ");
	var t_glslVersionStr=c_Renderer.m_mShadingVersionStr.split(" ");
	c_Renderer.m_mVersion=parseFloat(t_glVersionStr[t_glVersionStr.length-1]);
	c_Renderer.m_mShadingVersion=parseFloat(t_glslVersionStr[t_glslVersionStr.length-1]);
	c_Renderer.m_mDefaultProgram=c_Renderer.m_CreateProgram("#ifdef GL_ES\nprecision highp int;\nprecision mediump float;\n#endif\nuniform mat4 mvp;uniform mat4 modelView;uniform mat4 normalMatrix;uniform mat4 invView;uniform mat4 depthBias;uniform int baseTexMode;uniform bool useNormalTex;uniform bool useReflectTex;uniform bool useRefractTex;uniform bool usePixelLighting;uniform int numLights;uniform vec4 lightPos[MAX_LIGHTS];uniform vec3 lightColor[MAX_LIGHTS];uniform float lightRadius[MAX_LIGHTS];uniform vec4 baseColor;uniform vec3 ambient;uniform float shininess;uniform float refractCoef;uniform bool fogEnabled;uniform vec2 fogDist;uniform bool skinned;uniform mat4 bones[MAX_BONES];attribute vec3 vpos;attribute vec3 vnormal;attribute vec3 vtangent;attribute vec4 vcolor;attribute vec2 vtex;attribute vec2 vtex2;attribute vec4 vboneIndices;attribute vec4 vboneWeights;varying vec3 fpos;varying vec3 fposNorm;varying vec3 fnormal;varying vec4 fcolor;varying vec2 ftex;varying vec2 ftex2;varying vec3 fcombinedSpecular;varying float fogFactor;varying vec3 fcubeCoords;varying vec3 freflectCoords;varying vec3 frefractCoords;varying vec3 fdepthCoords;varying mat3 tbnMatrix;struct LightingResult { vec3 combinedDiffuse; vec3 combinedSpecular; };LightingResult CalcLighting(vec3 V, vec3 NV, vec3 N) {\tfloat normShininess = float(shininess) / 10240.0;\tLightingResult lighting;\tlighting.combinedDiffuse = ambient;\tlighting.combinedSpecular = vec3(0.0, 0.0, 0.0);\tfor ( int i = 0; i < MAX_LIGHTS; ++i ) {\t\tif ( i >= numLights ) break;   \tvec3 L = vec3(lightPos[i]);   \tfloat att = 1.0;\t\tif ( lightPos[i].w == 1.0 ) {\t\t\tL -= V;\t\t\tatt = 1.0 - clamp(length(L) / lightRadius[i], 0.0, 1.0);\t\t}\t\tL = normalize(L);\t\tfloat NdotL = max(dot(N, L), 0.0);\t\tlighting.combinedDiffuse += NdotL * lightColor[i] * att;\t\tif ( shininess > 0.0 && NdotL > 0.0 ) {\t\t\tvec3 H = normalize(L - NV);\t\t\tfloat NdotH = max(dot(N, H), 0.0);\t\t\tlighting.combinedSpecular += pow(NdotH, shininess * 128.0) * lightColor[i] * shininess * 0.5 * att;\t\t}\n\t}\n\tlighting.combinedDiffuse = clamp(lighting.combinedDiffuse, 0.0, 1.0);\tlighting.combinedSpecular = clamp(lighting.combinedSpecular, 0.0, 1.0);\treturn lighting;}void main() {\tvec4 vpos4 = vec4(vpos, 1);\tif ( skinned ) {\t\tmat4 boneTransform = mat4(1);\t\tfor ( int i = 0; i < 4; ++i ) {\t\t\tint index = int(vboneIndices[i]);\t\t\tif ( index > -1 ) boneTransform += bones[index] * vboneWeights[i];\t\t}\t\tvpos4 = boneTransform * vpos4;\t};\tgl_Position = mvp * vpos4;\tfdepthCoords = vec3(depthBias * vpos4);\tfcolor = baseColor * vcolor;\tftex = vtex;\tftex2 = vtex2;\tvec3 V;\tvec3 NV;\tvec3 N;\tif ( numLights > 0 || baseTexMode == 2 || useNormalTex || useReflectTex || useRefractTex || fogEnabled ) { \t\tV = vec3(modelView * vpos4);\t\tif ( numLights > 0 || baseTexMode == 2 || useNormalTex || useReflectTex || useRefractTex ) {\t\t\tNV = normalize(V);\t\t\tN = normalize(vec3(normalMatrix * vec4(vnormal, 0.0)));\t\t}\n\t}\n\tif ( numLights > 0 ) {\t\tif ( !usePixelLighting && !useNormalTex ) {\t\t\tLightingResult lighting = CalcLighting(V, NV, N);\t\t\tfcolor *= vec4(lighting.combinedDiffuse, 1.0);\t\t\tfcombinedSpecular = lighting.combinedSpecular;\t\t} else {\t\t\tfpos = V;\t\t\tfposNorm = NV;\t\t\tfnormal = N;\t\t}\t}\tif ( fogEnabled ) fogFactor = clamp((fogDist[1] - abs(V.z)) / (fogDist[1] - fogDist[0]), 0.0, 1.0);\tif ( baseTexMode == 2 || useReflectTex || useRefractTex ) { \t\tif ( baseTexMode == 2 ) fcubeCoords = vec3(invView * vec4(NV, 0));\t\tif ( useReflectTex ) freflectCoords = normalize(vec3(invView * vec4(reflect(NV, N), 0)));\t\tif ( useRefractTex ) frefractCoords = normalize(vec3(invView * vec4(refract(NV, N, refractCoef), 0)));\t}\tif ( numLights > 0 && useNormalTex ) { \t\tvec3 eyeTangent = normalize(vec3(normalMatrix * vec4(vtangent, 0)));\t\tvec3 eyeBitangent = cross(eyeTangent, N);\t\ttbnMatrix = mat3(eyeTangent, eyeBitangent, N);\t}}","#ifdef GL_ES\nprecision highp int;\nprecision mediump float;\n#endif\nuniform int baseTexMode;uniform bool useNormalTex;uniform bool useLightmap;uniform bool useReflectTex;uniform bool useRefractTex;uniform sampler2D baseTexSampler;uniform samplerCube baseCubeSampler;uniform sampler2D normalTexSampler;uniform sampler2D lightmapSampler;uniform sampler2D depthSampler;uniform samplerCube reflectCubeSampler;uniform samplerCube refractCubeSampler;uniform bool usePixelLighting;uniform int numLights;uniform vec4 lightPos[MAX_LIGHTS];uniform vec3 lightColor[MAX_LIGHTS];uniform float lightRadius[MAX_LIGHTS];uniform vec3 ambient;uniform float shininess;uniform bool fogEnabled;uniform vec3 fogColor;uniform bool shadowsEnabled;uniform float depthEpsilon;varying vec3 fpos;varying vec3 fposNorm;varying vec3 fnormal;varying vec4 fcolor;varying vec2 ftex;varying vec2 ftex2;varying vec3 fcombinedSpecular;varying float fogFactor;varying vec3 fcubeCoords;varying vec3 freflectCoords;varying vec3 frefractCoords;varying vec3 fdepthCoords;varying mat3 tbnMatrix;struct LightingResult { vec3 combinedDiffuse; vec3 combinedSpecular; };LightingResult CalcLighting(vec3 V, vec3 NV, vec3 N) {\tfloat normShininess = float(shininess) / 10240.0;\tLightingResult lighting;\tlighting.combinedDiffuse = ambient;\tlighting.combinedSpecular = vec3(0.0, 0.0, 0.0);\tfor ( int i = 0; i < MAX_LIGHTS; ++i ) {\t\tif ( i >= numLights ) break;   \tvec3 L = vec3(lightPos[i]);   \tfloat att = 1.0;\t\tif ( lightPos[i].w == 1.0 ) {\t\t\tL -= V;\t\t\tatt = 1.0 - clamp(length(L) / lightRadius[i], 0.0, 1.0);\t\t}\t\tL = normalize(L);\t\tfloat NdotL = max(dot(N, L), 0.0);\t\tlighting.combinedDiffuse += NdotL * lightColor[i] * att;\t\tif ( shininess > 0.0 && NdotL > 0.0 ) {\t\t\tvec3 H = normalize(L - NV);\t\t\tfloat NdotH = max(dot(N, H), 0.0);\t\t\tlighting.combinedSpecular += pow(NdotH, shininess * 128.0) * lightColor[i] * shininess * 0.5 * att;\t\t}\n\t}\n\tlighting.combinedDiffuse = clamp(lighting.combinedDiffuse, 0.0, 1.0);\tlighting.combinedSpecular = clamp(lighting.combinedSpecular, 0.0, 1.0);\treturn lighting;}void main() {\tvec4 combinedColor;\tvec3 combinedSpecular = vec3(0, 0, 0);\tcombinedColor = fcolor;\tif ( numLights > 0 && (usePixelLighting || useNormalTex) ) {\t\tvec3 normal = fnormal;\t\tif ( useNormalTex ) {\t\t\tvec3 normalTexColor = vec3(texture2D(normalTexSampler, ftex));\t\t\tnormal = tbnMatrix * (normalTexColor*2.0 - 1.0);\t\t}\t\tLightingResult lighting = CalcLighting(fpos, fposNorm, normal);\t\tcombinedColor *= vec4(lighting.combinedDiffuse, 1.0);\t\tcombinedSpecular = lighting.combinedSpecular;\t}\tif ( useLightmap ) {\t\tif ( numLights > 0 ) combinedColor += vec4(vec3(texture2D(lightmapSampler, ftex2)), 0.0);\t\telse combinedColor *= texture2D(lightmapSampler, ftex2);\t}\tif ( baseTexMode == 1 ) combinedColor *= texture2D(baseTexSampler, ftex);\telse if ( baseTexMode == 2 ) combinedColor *= textureCube(baseCubeSampler, fcubeCoords);\tif ( combinedColor.a <= 0.004 ) discard;\tif ( useReflectTex ) {\t\tcombinedColor *= textureCube(reflectCubeSampler, freflectCoords);\t}\tif ( useRefractTex ) {\t\tcombinedColor *= textureCube(refractCubeSampler, frefractCoords);\t}\tif ( numLights > 0 ) {\t\tif ( usePixelLighting || useNormalTex ) combinedColor += vec4(combinedSpecular, 0.0);\t\telse combinedColor += vec4(fcombinedSpecular, 0.0);\t\tcombinedColor = clamp(combinedColor, 0.0, 1.0);\t}\tif ( shadowsEnabled && texture2D(depthSampler, vec2(fdepthCoords)).z < fdepthCoords.z - depthEpsilon ) combinedColor *= vec4(ambient, 1);\tif ( fogEnabled ) combinedColor = vec4(mix(fogColor, vec3(combinedColor), fogFactor), combinedColor.a);\tgl_FragColor = combinedColor;}");
	if(c_Renderer.m_mDefaultProgram==null){
		return false;
	}
	c_Renderer.m_mDepthProgram=c_Renderer.m_CreateProgram("#ifdef GL_ES\nprecision highp int;\nprecision mediump float;\n#endif\nuniform mat4 mvp;attribute vec3 vpos;void main() {\tgl_Position = mvp * vec4(vpos, 1);}","#ifdef GL_ES\nprecision highp int;\nprecision mediump float;\n#endif\nvoid main() {\tfloat depth = gl_FragCoord.z / gl_FragCoord.w;\tgl_FragColor = vec4(depth, depth, depth, 1);}");
	if(c_Renderer.m_mDepthProgram==null){
		return false;
	}
	c_Renderer.m_m2DProgram=c_Renderer.m_CreateProgram("#ifdef GL_ES\nprecision highp int;\nprecision mediump float;\n#endif\nuniform mat4 mvp;attribute vec3 vpos;attribute vec2 vtex;varying vec2 ftex;void main() {\tgl_Position = mvp * vec4(vpos, 1.0);\tftex = vtex;}","#ifdef GL_ES\nprecision highp int;\nprecision mediump float;\n#endif\nuniform int baseTexMode;uniform sampler2D baseTexSampler;uniform samplerCube baseCubeSampler;uniform vec4 baseColor;varying vec2 ftex;void main() {\tgl_FragColor = baseColor;\tif ( baseTexMode == 1 ) gl_FragColor *= texture2D(baseTexSampler, ftex);\telse if ( baseTexMode == 2 ) gl_FragColor *= textureCube(baseCubeSampler, vec3(ftex.x, -ftex.y, 1));}");
	if(c_Renderer.m_m2DProgram==null){
		return false;
	}
	c_Renderer.m_UseProgram(c_Renderer.m_mDefaultProgram);
	if(c_Renderer.m_mEllipseBuffer!=0){
		c_Renderer.m_FreeBuffer(c_Renderer.m_mEllipseBuffer);
	}
	if(c_Renderer.m_mLineBuffer!=0){
		c_Renderer.m_FreeBuffer(c_Renderer.m_mLineBuffer);
	}
	if(c_Renderer.m_mRectBuffer!=0){
		c_Renderer.m_FreeBuffer(c_Renderer.m_mRectBuffer);
	}
	var t_dataBuffer=c_DataBuffer.m_new.call(new c_DataBuffer,768,true);
	var t_inc=5.625;
	for(var t_i=0;t_i<64;t_i=t_i+1){
		var t_x=0.5+0.5*Math.cos(((t_i)*t_inc)*D2R);
		var t_y=0.5+0.5*Math.sin(((t_i)*t_inc)*D2R);
		t_dataBuffer.PokeFloat(t_i*12,t_x);
		t_dataBuffer.PokeFloat(t_i*12+4,t_y);
		t_dataBuffer.PokeFloat(t_i*12+8,0.0);
	}
	c_Renderer.m_mEllipseBuffer=c_Renderer.m_CreateVertexBuffer(t_dataBuffer.Length());
	c_Renderer.m_SetVertexBufferData(c_Renderer.m_mEllipseBuffer,0,t_dataBuffer.Length(),t_dataBuffer);
	t_dataBuffer.Discard();
	t_dataBuffer=c_DataBuffer.m_new.call(new c_DataBuffer,24,true);
	t_dataBuffer.PokeFloat(0,0.0);
	t_dataBuffer.PokeFloat(4,0.0);
	t_dataBuffer.PokeFloat(8,0.0);
	t_dataBuffer.PokeFloat(12,1.0);
	t_dataBuffer.PokeFloat(16,1.0);
	t_dataBuffer.PokeFloat(20,0.0);
	c_Renderer.m_mLineBuffer=c_Renderer.m_CreateVertexBuffer(t_dataBuffer.Length());
	c_Renderer.m_SetVertexBufferData(c_Renderer.m_mLineBuffer,0,t_dataBuffer.Length(),t_dataBuffer);
	t_dataBuffer.Discard();
	t_dataBuffer=c_DataBuffer.m_new.call(new c_DataBuffer,80,true);
	t_dataBuffer.PokeFloat(0,0.0);
	t_dataBuffer.PokeFloat(4,0.0);
	t_dataBuffer.PokeFloat(8,0.0);
	t_dataBuffer.PokeFloat(12,1.0);
	t_dataBuffer.PokeFloat(16,0.0);
	t_dataBuffer.PokeFloat(20,0.0);
	t_dataBuffer.PokeFloat(24,1.0);
	t_dataBuffer.PokeFloat(28,1.0);
	t_dataBuffer.PokeFloat(32,0.0);
	t_dataBuffer.PokeFloat(36,0.0);
	t_dataBuffer.PokeFloat(40,1.0);
	t_dataBuffer.PokeFloat(44,0.0);
	c_Renderer.m_mRectBuffer=c_Renderer.m_CreateVertexBuffer(t_dataBuffer.Length());
	c_Renderer.m_SetVertexBufferData(c_Renderer.m_mRectBuffer,0,t_dataBuffer.Length(),t_dataBuffer);
	t_dataBuffer.Discard();
	return true;
}
c_Renderer.m_ResizeIndexBuffer=function(t_buffer,t_size){
	_glBindBuffer(34963,t_buffer);
	_glBufferData(34963,t_size,null,35044);
	_glBindBuffer(34963,0);
}
c_Renderer.m_CreateIndexBuffer=function(t_size){
	var t_buffer=gl.createBuffer();
	if(t_size>0){
		c_Renderer.m_ResizeIndexBuffer(t_buffer,t_size);
	}
	return t_buffer;
}
c_Renderer.m_SetIndexBufferData=function(t_buffer,t_offset,t_size,t_data){
	_glBindBuffer(34963,t_buffer);
	_glBufferSubData(34963,t_offset,t_size,t_data,0);
	_glBindBuffer(34963,0);
}
c_Renderer.m_CreateTexture=function(t_width,t_height){
	var t_texture=gl.createTexture();
	_glBindTexture(3553,t_texture);
	gl.texParameteri(3553,10240,9728);
	gl.texParameteri(3553,10241,9728);
	_glTexImage2D(3553,0,6408,t_width,t_height,0,6408,5121,null);
	return t_texture;
}
c_Renderer.m_MagFilter=function(t_filtering){
	var t_3=t_filtering;
	if(t_3==0){
		return 9728;
	}else{
		if(t_3==1){
			return 9729;
		}else{
			if(t_3==2){
				return 9729;
			}else{
				if(t_3==3){
					return 9729;
				}else{
					return 9729;
				}
			}
		}
	}
}
c_Renderer.m_MinFilter=function(t_filtering,t_isCubeMap){
	var t_4=t_filtering;
	if(t_4==0){
		return 9728;
	}else{
		if(t_4==1){
			return 9729;
		}else{
			if(t_4==2){
				if(!t_isCubeMap){
					return 9985;
				}else{
					return 9729;
				}
			}else{
				if(t_4==3){
					if(!t_isCubeMap){
						return 9987;
					}else{
						return 9729;
					}
				}else{
					return 9729;
				}
			}
		}
	}
}
c_Renderer.m_CreateTexture2=function(t_buffer,t_width,t_height,t_filter){
	var t_texture=gl.createTexture();
	_glBindTexture(3553,t_texture);
	gl.texParameteri(3553,10240,c_Renderer.m_MagFilter(t_filter));
	gl.texParameteri(3553,10241,c_Renderer.m_MinFilter(t_filter,false));
	_glTexImage2D(3553,0,6408,t_width,t_height,0,6408,5121,t_buffer);
	if(t_filter>1){
		_glGenerateMipmap(3553);
	}
	return t_texture;
}
c_Renderer.m_CreateRenderbuffer=function(t_width,t_height){
	var t_rb=gl.createRenderbuffer();
	_glBindRenderbuffer(36161,t_rb);
	gl.renderbufferStorage(36161,33189,t_width,t_height);
	_glBindRenderbuffer(36161,0);
	return t_rb;
}
c_Renderer.m_SetFramebuffer=function(t_fb){
	_glBindFramebuffer(36160,t_fb);
}
c_Renderer.m_CreateFramebuffer=function(t_colorTex,t_depthBuffer){
	var t_fb=gl.createFramebuffer();
	c_Renderer.m_SetFramebuffer(t_fb);
	gl.framebufferTexture2D(36160,36064,3553,t_colorTex,0);
	if(t_depthBuffer!=0){
		gl.framebufferRenderbuffer(36160,36096,36161,t_depthBuffer);
	}
	c_Renderer.m_SetFramebuffer(0);
	return t_fb;
}
c_Renderer.m_ProgramError=function(){
	return c_Renderer.m_mProgramError;
}
c_Renderer.m_VendorName=function(){
	return c_Renderer.m_mVendor;
}
c_Renderer.m_RendererName=function(){
	return c_Renderer.m_mRenderer;
}
c_Renderer.m_APIVersionName=function(){
	return c_Renderer.m_mVersionStr;
}
c_Renderer.m_ShadingVersionName=function(){
	return c_Renderer.m_mShadingVersionStr;
}
c_Renderer.m_LoadTexture=function(t_filename,t_size,t_filter){
	if(t_size.length>=2){
		var t_img=bb_graphics_LoadImage(t_filename,1,c_Image.m_DefaultFlags);
		if(t_img!=null){
			t_size[0]=t_img.p_Width();
			t_size[1]=t_img.p_Height();
			t_img.p_Discard();
		}else{
			t_size[0]=0;
			t_size[1]=0;
			return 0;
		}
	}
	if(String.fromCharCode(t_filename.charCodeAt(0))!="/" && String.fromCharCode(t_filename.charCodeAt(1))!=":"){
		t_filename="cerberus://data/"+t_filename;
	}
	var t_texture=gl.createTexture();
	_glBindTexture(3553,t_texture);
	gl.texParameteri(3553,10240,c_Renderer.m_MagFilter(t_filter));
	gl.texParameteri(3553,10241,c_Renderer.m_MinFilter(t_filter,false));
	_glTexImage2D3(3553,0,6408,6408,5121,t_filename);
	if(t_filter>1){
		_glGenerateMipmap(3553);
	}
	return t_texture;
}
c_Renderer.m_LoadCubicTexture=function(t_left,t_right,t_front,t_back,t_top,t_bottom,t_size,t_filter){
	if(t_size.length>=2){
		var t_img=bb_graphics_LoadImage(t_left,1,c_Image.m_DefaultFlags);
		if(t_img!=null){
			t_size[0]=t_img.p_Width();
			t_size[1]=t_img.p_Height();
			t_img.p_Discard();
		}else{
			t_size[0]=0;
			t_size[1]=0;
			return 0;
		}
	}
	if(String.fromCharCode(t_left.charCodeAt(0))!="/" && String.fromCharCode(t_left.charCodeAt(1))!=":"){
		t_left="cerberus://data/"+t_left;
	}
	if(String.fromCharCode(t_right.charCodeAt(0))!="/" && String.fromCharCode(t_right.charCodeAt(1))!=":"){
		t_right="cerberus://data/"+t_right;
	}
	if(String.fromCharCode(t_front.charCodeAt(0))!="/" && String.fromCharCode(t_front.charCodeAt(1))!=":"){
		t_front="cerberus://data/"+t_front;
	}
	if(String.fromCharCode(t_back.charCodeAt(0))!="/" && String.fromCharCode(t_back.charCodeAt(1))!=":"){
		t_back="cerberus://data/"+t_back;
	}
	if(String.fromCharCode(t_top.charCodeAt(0))!="/" && String.fromCharCode(t_top.charCodeAt(1))!=":"){
		t_top="cerberus://data/"+t_top;
	}
	if(String.fromCharCode(t_bottom.charCodeAt(0))!="/" && String.fromCharCode(t_bottom.charCodeAt(1))!=":"){
		t_bottom="cerberus://data/"+t_bottom;
	}
	var t_texture=gl.createTexture();
	_glBindTexture(34067,t_texture);
	gl.texParameteri(34067,10242,33071);
	gl.texParameteri(34067,10243,33071);
	gl.texParameteri(34067,10240,c_Renderer.m_MagFilter(t_filter));
	gl.texParameteri(34067,10241,c_Renderer.m_MinFilter(t_filter,true));
	_glTexImage2D3(34070,0,6408,6408,5121,t_left);
	_glTexImage2D3(34069,0,6408,6408,5121,t_right);
	_glTexImage2D3(34074,0,6408,6408,5121,t_back);
	_glTexImage2D3(34073,0,6408,6408,5121,t_front);
	_glTexImage2D3(34071,0,6408,6408,5121,t_top);
	_glTexImage2D3(34072,0,6408,6408,5121,t_bottom);
	if(t_filter>1){
		_glGenerateMipmap(34067);
	}
	return t_texture;
}
c_Renderer.m_SetPixelLighting=function(t_enable){
	if(c_Renderer.m_mActiveProgram.m_mUsePixelLightingLoc!=-1){
		gl.uniform1i(c_Renderer.m_mActiveProgram.m_mUsePixelLightingLoc,((t_enable)?1:0));
	}
}
c_Renderer.m_SetNumLights=function(t_num){
	if(c_Renderer.m_mActiveProgram.m_mNumLightsLoc!=-1){
		gl.uniform1i(c_Renderer.m_mActiveProgram.m_mNumLightsLoc,t_num);
	}
}
c_Renderer.m_SetCulling=function(t_enable){
	if(t_enable){
		gl.enable(2884);
	}else{
		gl.disable(2884);
	}
}
c_Renderer.m_SetDepthWrite=function(t_enable){
	gl.depthMask(t_enable);
}
c_Renderer.m_SetBlendMode=function(t_mode){
	var t_1=t_mode;
	if(t_1==0){
		gl.blendFunc(770,771);
	}else{
		if(t_1==1){
			gl.blendFunc(770,1);
		}else{
			if(t_1==2){
				gl.blendFunc(774,0);
			}
		}
	}
}
c_Renderer.m_SetColor=function(t_r,t_g,t_b,t_a){
	if(c_Renderer.m_mActiveProgram.m_mBaseColorLoc!=-1){
		gl.uniform4f(c_Renderer.m_mActiveProgram.m_mBaseColorLoc,t_r,t_g,t_b,t_a);
	}
}
c_Renderer.m_SetColor2=function(t_color){
	c_Renderer.m_SetColor((c_Color.m_Red(t_color))/255.0,(c_Color.m_Green(t_color))/255.0,(c_Color.m_Blue(t_color))/255.0,(c_Color.m_Alpha(t_color))/255.0);
}
c_Renderer.m_SetSkinned=function(t_enable){
	if(c_Renderer.m_mActiveProgram.m_mSkinnedLoc!=-1){
		gl.uniform1i(c_Renderer.m_mActiveProgram.m_mSkinnedLoc,((t_enable)?1:0));
	}
}
c_Renderer.m_mTempMatrix=null;
c_Renderer.m_mDepthBiasMatrix=null;
c_Renderer.m_SetDepthData=function(t_depthProj,t_depthView,t_depthTex,t_depthEpsilon){
	c_Renderer.m_mDepthBiasMatrix.p_SetIdentity();
	c_Renderer.m_mDepthBiasMatrix.m_M[0]=0.5;
	c_Renderer.m_mDepthBiasMatrix.m_M[5]=0.5;
	c_Renderer.m_mDepthBiasMatrix.m_M[10]=0.5;
	c_Renderer.m_mDepthBiasMatrix.m_M[12]=0.5;
	c_Renderer.m_mDepthBiasMatrix.m_M[13]=0.5;
	c_Renderer.m_mDepthBiasMatrix.m_M[14]=0.5;
	c_Renderer.m_mDepthBiasMatrix.p_Mul6(t_depthProj);
	c_Renderer.m_mDepthBiasMatrix.p_Mul6(t_depthView);
	gl.activeTexture(33990);
	_glBindTexture(3553,t_depthTex);
	gl.activeTexture(33984);
	if(c_Renderer.m_mActiveProgram.m_mShadowsEnabledLoc!=-1 && c_Renderer.m_mActiveProgram.m_mDepthEpsilonLoc!=-1){
		if(t_depthTex!=0){
			gl.uniform1i(c_Renderer.m_mActiveProgram.m_mShadowsEnabledLoc,1);
			gl.uniform1f(c_Renderer.m_mActiveProgram.m_mDepthEpsilonLoc,t_depthEpsilon);
		}else{
			gl.uniform1i(c_Renderer.m_mActiveProgram.m_mShadowsEnabledLoc,0);
			gl.uniform1f(c_Renderer.m_mActiveProgram.m_mDepthEpsilonLoc,t_depthEpsilon);
		}
	}
}
c_Renderer.m_Setup3D=function(t_x,t_y,t_w,t_h,t_isDepthPass,t_framebufferHeight){
	if(t_framebufferHeight==0){
		t_framebufferHeight=t_h;
	}
	if(!t_isDepthPass){
		c_Renderer.m_UseProgram(c_Renderer.m_mDefaultProgram);
	}else{
		c_Renderer.m_UseProgram(c_Renderer.m_mDepthProgram);
	}
	gl.enable(3042);
	gl.enable(2929);
	gl.enable(3089);
	gl.depthFunc(515);
	c_Renderer.m_SetPixelLighting(false);
	c_Renderer.m_SetNumLights(0);
	c_Renderer.m_SetCulling(true);
	gl.frontFace(2304);
	c_Renderer.m_SetDepthWrite(true);
	c_Renderer.m_SetBlendMode(0);
	c_Renderer.m_SetColor(1.0,1.0,1.0,1.0);
	c_Renderer.m_SetSkinned(false);
	t_y=t_framebufferHeight-t_y-t_h;
	gl.viewport(t_x,t_y,t_w,t_h);
	gl.scissor(t_x,t_y,t_w,t_h);
	c_Renderer.m_mTempMatrix.p_SetIdentity();
	c_Renderer.m_SetDepthData(c_Renderer.m_mTempMatrix,c_Renderer.m_mTempMatrix,0,0.0);
}
c_Renderer.m_mProjectionMatrix=null;
c_Renderer.m_SetProjectionMatrix=function(t_m){
	c_Renderer.m_mProjectionMatrix.p_Set9(t_m);
}
c_Renderer.m_mViewMatrix=null;
c_Renderer.m_mInvViewMatrix=null;
c_Renderer.m_SetViewMatrix=function(t_m){
	c_Renderer.m_mViewMatrix.p_Set9(t_m);
	c_Renderer.m_mInvViewMatrix.p_Set9(t_m);
	c_Renderer.m_mInvViewMatrix.p_Invert();
}
c_Renderer.m_ClearColorBuffer=function(t_color){
	gl.clearColor((c_Color.m_Red(t_color))/255.0,(c_Color.m_Green(t_color))/255.0,(c_Color.m_Blue(t_color))/255.0,(c_Color.m_Alpha(t_color))/255.0);
	gl.clear(16384);
}
c_Renderer.m_ClearDepthBuffer=function(){
	gl.clear(256);
}
c_Renderer.m_SetShininess=function(t_shininess){
	if(c_Renderer.m_mActiveProgram.m_mShininessLoc!=-1){
		gl.uniform1f(c_Renderer.m_mActiveProgram.m_mShininessLoc,t_shininess);
	}
}
c_Renderer.m_SetRefractCoef=function(t_coef){
	if(c_Renderer.m_mActiveProgram.m_mRefractCoefLoc!=-1){
		gl.uniform1f(c_Renderer.m_mActiveProgram.m_mRefractCoefLoc,t_coef);
	}
}
c_Renderer.m_SetTextures=function(t_diffuseTex,t_normalTex,t_lightmap,t_reflectionTex,t_refractionTex,t_isDiffuseCubic){
	if(t_diffuseTex!=0){
		if(!t_isDiffuseCubic){
			gl.activeTexture(33984);
			_glBindTexture(3553,t_diffuseTex);
		}else{
			gl.activeTexture(33985);
			_glBindTexture(34067,t_diffuseTex);
		}
	}
	if(t_normalTex!=0){
		gl.activeTexture(33986);
		_glBindTexture(3553,t_normalTex);
	}
	if(t_lightmap!=0){
		gl.activeTexture(33987);
		_glBindTexture(3553,t_lightmap);
	}
	if(t_reflectionTex!=0){
		gl.activeTexture(33988);
		_glBindTexture(34067,t_reflectionTex);
	}
	if(t_refractionTex!=0){
		gl.activeTexture(33989);
		_glBindTexture(34067,t_refractionTex);
	}
	if(c_Renderer.m_mActiveProgram.m_mBaseTexModeLoc!=-1){
		if(t_diffuseTex==0){
			gl.uniform1i(c_Renderer.m_mActiveProgram.m_mBaseTexModeLoc,0);
		}else{
			if(!t_isDiffuseCubic){
				gl.uniform1i(c_Renderer.m_mActiveProgram.m_mBaseTexModeLoc,1);
			}else{
				gl.uniform1i(c_Renderer.m_mActiveProgram.m_mBaseTexModeLoc,2);
			}
		}
	}
	if(c_Renderer.m_mActiveProgram.m_mUseNormalTexLoc!=-1){
		gl.uniform1i(c_Renderer.m_mActiveProgram.m_mUseNormalTexLoc,((t_normalTex!=0)?1:0));
	}
	if(c_Renderer.m_mActiveProgram.m_mUseLightmapLoc!=-1){
		gl.uniform1i(c_Renderer.m_mActiveProgram.m_mUseLightmapLoc,((t_lightmap!=0)?1:0));
	}
	if(c_Renderer.m_mActiveProgram.m_mUseReflectTexLoc!=-1){
		gl.uniform1i(c_Renderer.m_mActiveProgram.m_mUseReflectTexLoc,((t_reflectionTex!=0)?1:0));
	}
	if(c_Renderer.m_mActiveProgram.m_mUseRefractTexLoc!=-1){
		gl.uniform1i(c_Renderer.m_mActiveProgram.m_mUseRefractTexLoc,((t_refractionTex!=0)?1:0));
	}
	gl.activeTexture(33984);
}
c_Renderer.m_SetBoneMatrices=function(t_matrices){
	if(c_Renderer.m_mActiveProgram.m_mBonesLoc[0]!=-1){
		var t_lastIndex=bb_math_Min(c_Renderer.m_mMaxBones,t_matrices.length);
		for(var t_i=0;t_i<t_lastIndex;t_i=t_i+1){
			if(c_Renderer.m_mActiveProgram.m_mBonesLoc[t_i]!=-1){
				_glUniformMatrix4fv(c_Renderer.m_mActiveProgram.m_mBonesLoc[t_i],1,false,t_matrices[t_i].m_M);
			}
		}
	}
}
c_Renderer.m_mModelMatrix=null;
c_Renderer.m_SetModelMatrix=function(t_m){
	if(t_m!=c_Renderer.m_mModelMatrix){
		c_Renderer.m_mModelMatrix.p_Set9(t_m);
	}
	if(c_Renderer.m_mActiveProgram.m_mModelViewLoc!=-1 || c_Renderer.m_mActiveProgram.m_mNormalMatrixLoc!=-1){
		c_Renderer.m_mTempMatrix.p_Set9(c_Renderer.m_mViewMatrix);
		c_Renderer.m_mTempMatrix.p_Mul6(c_Renderer.m_mModelMatrix);
		_glUniformMatrix4fv(c_Renderer.m_mActiveProgram.m_mModelViewLoc,1,false,c_Renderer.m_mTempMatrix.m_M);
	}
	if(c_Renderer.m_mActiveProgram.m_mNormalMatrixLoc!=-1){
		c_Renderer.m_mTempMatrix.p_Invert();
		c_Renderer.m_mTempMatrix.p_Transpose();
		_glUniformMatrix4fv(c_Renderer.m_mActiveProgram.m_mNormalMatrixLoc,1,false,c_Renderer.m_mTempMatrix.m_M);
	}
	if(c_Renderer.m_mActiveProgram.m_mInvViewLoc!=-1){
		_glUniformMatrix4fv(c_Renderer.m_mActiveProgram.m_mInvViewLoc,1,false,c_Renderer.m_mInvViewMatrix.m_M);
	}
	if(c_Renderer.m_mActiveProgram.m_mMVPLoc!=-1){
		c_Renderer.m_mTempMatrix.p_Set9(c_Renderer.m_mProjectionMatrix);
		c_Renderer.m_mTempMatrix.p_Mul6(c_Renderer.m_mViewMatrix);
		c_Renderer.m_mTempMatrix.p_Mul6(c_Renderer.m_mModelMatrix);
		_glUniformMatrix4fv(c_Renderer.m_mActiveProgram.m_mMVPLoc,1,false,c_Renderer.m_mTempMatrix.m_M);
	}
	if(c_Renderer.m_mActiveProgram.m_mDepthBiasLoc!=-1){
		c_Renderer.m_mTempMatrix.p_Set9(c_Renderer.m_mDepthBiasMatrix);
		c_Renderer.m_mTempMatrix.p_Mul6(c_Renderer.m_mModelMatrix);
		_glUniformMatrix4fv(c_Renderer.m_mActiveProgram.m_mDepthBiasLoc,1,false,c_Renderer.m_mTempMatrix.m_M);
	}
}
c_Renderer.m_DrawBuffers=function(t_vertexBuffer,t_indexBuffer,t_numIndices,t_coordsOffset,t_normalsOffset,t_tangentsOffset,t_colorsOffset,t_texCoordsOffset,t_texCoords2Offset,t_boneIndicesOffset,t_boneWeightsOffset,t_stride){
	_glBindBuffer(34962,t_vertexBuffer);
	_glBindBuffer(34963,t_indexBuffer);
	if(t_coordsOffset>=0 && c_Renderer.m_mActiveProgram.m_mVPosLoc>-1){
		gl.enableVertexAttribArray(c_Renderer.m_mActiveProgram.m_mVPosLoc);
		gl.vertexAttribPointer(c_Renderer.m_mActiveProgram.m_mVPosLoc,3,5126,false,t_stride,t_coordsOffset);
	}
	if(t_normalsOffset>=0 && c_Renderer.m_mActiveProgram.m_mVNormalLoc>-1){
		gl.enableVertexAttribArray(c_Renderer.m_mActiveProgram.m_mVNormalLoc);
		gl.vertexAttribPointer(c_Renderer.m_mActiveProgram.m_mVNormalLoc,3,5126,false,t_stride,t_normalsOffset);
	}
	if(t_tangentsOffset>=0 && c_Renderer.m_mActiveProgram.m_mVTangentLoc>-1){
		gl.enableVertexAttribArray(c_Renderer.m_mActiveProgram.m_mVTangentLoc);
		gl.vertexAttribPointer(c_Renderer.m_mActiveProgram.m_mVTangentLoc,3,5126,false,t_stride,t_tangentsOffset);
	}
	if(t_colorsOffset>=0 && c_Renderer.m_mActiveProgram.m_mVColorLoc>-1){
		gl.enableVertexAttribArray(c_Renderer.m_mActiveProgram.m_mVColorLoc);
		gl.vertexAttribPointer(c_Renderer.m_mActiveProgram.m_mVColorLoc,4,5126,false,t_stride,t_colorsOffset);
	}
	if(t_texCoordsOffset>=0 && c_Renderer.m_mActiveProgram.m_mVTexLoc>-1){
		gl.enableVertexAttribArray(c_Renderer.m_mActiveProgram.m_mVTexLoc);
		gl.vertexAttribPointer(c_Renderer.m_mActiveProgram.m_mVTexLoc,2,5126,false,t_stride,t_texCoordsOffset);
	}
	if(t_texCoords2Offset>=0 && c_Renderer.m_mActiveProgram.m_mVTex2Loc>-1){
		gl.enableVertexAttribArray(c_Renderer.m_mActiveProgram.m_mVTex2Loc);
		gl.vertexAttribPointer(c_Renderer.m_mActiveProgram.m_mVTex2Loc,2,5126,false,t_stride,t_texCoords2Offset);
	}
	if(t_boneIndicesOffset>=0 && c_Renderer.m_mActiveProgram.m_mVBoneIndicesLoc>-1){
		gl.enableVertexAttribArray(c_Renderer.m_mActiveProgram.m_mVBoneIndicesLoc);
		gl.vertexAttribPointer(c_Renderer.m_mActiveProgram.m_mVBoneIndicesLoc,4,5126,false,t_stride,t_boneIndicesOffset);
	}
	if(t_boneWeightsOffset>=0 && c_Renderer.m_mActiveProgram.m_mVBoneWeightsLoc>-1){
		gl.enableVertexAttribArray(c_Renderer.m_mActiveProgram.m_mVBoneWeightsLoc);
		gl.vertexAttribPointer(c_Renderer.m_mActiveProgram.m_mVBoneWeightsLoc,4,5126,false,t_stride,t_boneWeightsOffset);
	}
	gl.drawElements(4,t_numIndices,5123,0);
	if(c_Renderer.m_mActiveProgram.m_mVPosLoc>-1){
		gl.disableVertexAttribArray(c_Renderer.m_mActiveProgram.m_mVPosLoc);
	}
	if(c_Renderer.m_mActiveProgram.m_mVNormalLoc>-1){
		gl.disableVertexAttribArray(c_Renderer.m_mActiveProgram.m_mVNormalLoc);
	}
	if(c_Renderer.m_mActiveProgram.m_mVTangentLoc>-1){
		gl.disableVertexAttribArray(c_Renderer.m_mActiveProgram.m_mVTangentLoc);
	}
	if(c_Renderer.m_mActiveProgram.m_mVColorLoc>-1){
		gl.disableVertexAttribArray(c_Renderer.m_mActiveProgram.m_mVColorLoc);
	}
	if(c_Renderer.m_mActiveProgram.m_mVTexLoc>-1){
		gl.disableVertexAttribArray(c_Renderer.m_mActiveProgram.m_mVTexLoc);
	}
	if(c_Renderer.m_mActiveProgram.m_mVTex2Loc>-1){
		gl.disableVertexAttribArray(c_Renderer.m_mActiveProgram.m_mVTex2Loc);
	}
	if(c_Renderer.m_mActiveProgram.m_mVBoneIndicesLoc>-1){
		gl.disableVertexAttribArray(c_Renderer.m_mActiveProgram.m_mVBoneIndicesLoc);
	}
	if(c_Renderer.m_mActiveProgram.m_mVBoneWeightsLoc>-1){
		gl.disableVertexAttribArray(c_Renderer.m_mActiveProgram.m_mVBoneWeightsLoc);
	}
	_glBindBuffer(34962,0);
	_glBindBuffer(34963,0);
}
c_Renderer.m_SetFog=function(t_enable,t_minDist,t_maxDist,t_r,t_g,t_b){
	if(c_Renderer.m_mActiveProgram.m_mFogEnabledLoc!=-1){
		gl.uniform1i(c_Renderer.m_mActiveProgram.m_mFogEnabledLoc,((t_enable)?1:0));
	}
	if(t_enable){
		if(c_Renderer.m_mActiveProgram.m_mFogDistLoc!=-1){
			gl.uniform2f(c_Renderer.m_mActiveProgram.m_mFogDistLoc,t_minDist,t_maxDist);
		}
		if(c_Renderer.m_mActiveProgram.m_mFogDistLoc!=-1){
			gl.uniform3f(c_Renderer.m_mActiveProgram.m_mFogColorLoc,t_r,t_g,t_b);
		}
	}
}
c_Renderer.m_SetAmbient=function(t_r,t_g,t_b){
	if(c_Renderer.m_mActiveProgram.m_mAmbientLoc!=-1){
		gl.uniform3f(c_Renderer.m_mActiveProgram.m_mAmbientLoc,t_r,t_g,t_b);
	}
}
c_Renderer.m_ViewMatrix=function(){
	return c_Renderer.m_mViewMatrix;
}
c_Renderer.m_SetLight=function(t_index,t_x,t_y,t_z,t_w,t_r,t_g,t_b,t_radius){
	if(c_Renderer.m_mActiveProgram.m_mLightPosLoc[t_index]!=-1){
		gl.uniform4f(c_Renderer.m_mActiveProgram.m_mLightPosLoc[t_index],t_x,t_y,t_z,t_w);
	}
	if(c_Renderer.m_mActiveProgram.m_mLightColorLoc[t_index]!=-1){
		gl.uniform3f(c_Renderer.m_mActiveProgram.m_mLightColorLoc[t_index],t_r,t_g,t_b);
	}
	if(c_Renderer.m_mActiveProgram.m_mLightRadiusLoc[t_index]!=-1){
		gl.uniform1f(c_Renderer.m_mActiveProgram.m_mLightRadiusLoc[t_index],t_radius);
	}
}
c_Renderer.m_Setup2D=function(t_x,t_y,t_w,t_h,t_framebufferHeight){
	if(t_framebufferHeight==0){
		t_framebufferHeight=t_h;
	}
	c_Renderer.m_UseProgram(c_Renderer.m_m2DProgram);
	c_Renderer.m_SetCulling(false);
	gl.disable(2929);
	gl.enable(3042);
	gl.enable(3089);
	gl.frontFace(2305);
	c_Renderer.m_SetBlendMode(0);
	c_Renderer.m_SetColor(1.0,1.0,1.0,1.0);
	t_y=t_framebufferHeight-t_y-t_h;
	gl.viewport(t_x,t_y,t_w,t_h);
	gl.scissor(t_x,t_y,t_w,t_h);
	c_Renderer.m_mTempMatrix.p_SetIdentity();
	c_Renderer.m_mTempMatrix.p_SetOrthoLH(0.0,(t_w),(t_h),0.0,0.0,100.0);
	c_Renderer.m_SetProjectionMatrix(c_Renderer.m_mTempMatrix);
	c_Renderer.m_mTempMatrix.p_SetIdentity();
	c_Renderer.m_SetViewMatrix(c_Renderer.m_mTempMatrix);
	c_Renderer.m_SetModelMatrix(c_Renderer.m_mTempMatrix);
}
c_Renderer.m_mTexDataBuffer=null;
c_Renderer.m_DrawRectEx=function(t_x,t_y,t_width,t_height,t_u0,t_v0,t_u1,t_v1){
	c_Renderer.m_mTexDataBuffer.PokeFloat(0,t_u0);
	c_Renderer.m_mTexDataBuffer.PokeFloat(4,t_v0);
	c_Renderer.m_mTexDataBuffer.PokeFloat(8,t_u1);
	c_Renderer.m_mTexDataBuffer.PokeFloat(12,t_v0);
	c_Renderer.m_mTexDataBuffer.PokeFloat(16,t_u1);
	c_Renderer.m_mTexDataBuffer.PokeFloat(20,t_v1);
	c_Renderer.m_mTexDataBuffer.PokeFloat(24,t_u0);
	c_Renderer.m_mTexDataBuffer.PokeFloat(28,t_v1);
	c_Renderer.m_SetVertexBufferData(c_Renderer.m_mRectBuffer,48,c_Renderer.m_mTexDataBuffer.Length(),c_Renderer.m_mTexDataBuffer);
	c_Renderer.m_mTempMatrix.p_SetTransform2(t_x,t_y,0.0,0.0,0.0,0.0,t_width,t_height,1.0);
	c_Renderer.m_SetModelMatrix(c_Renderer.m_mTempMatrix);
	_glBindBuffer(34962,c_Renderer.m_mRectBuffer);
	gl.enableVertexAttribArray(c_Renderer.m_mActiveProgram.m_mVPosLoc);
	gl.enableVertexAttribArray(c_Renderer.m_mActiveProgram.m_mVTexLoc);
	gl.vertexAttribPointer(c_Renderer.m_mActiveProgram.m_mVPosLoc,3,5126,false,0,0);
	gl.vertexAttribPointer(c_Renderer.m_mActiveProgram.m_mVTexLoc,2,5126,false,0,48);
	gl.drawArrays(6,0,4);
	gl.disableVertexAttribArray(c_Renderer.m_mActiveProgram.m_mVPosLoc);
	gl.disableVertexAttribArray(c_Renderer.m_mActiveProgram.m_mVTexLoc);
	_glBindBuffer(34962,0);
}
function c_GpuProgram(){
	Object.call(this);
	this.m_mProgramId=0;
	this.m_mMVPLoc=0;
	this.m_mModelViewLoc=0;
	this.m_mNormalMatrixLoc=0;
	this.m_mInvViewLoc=0;
	this.m_mDepthBiasLoc=0;
	this.m_mBaseTexModeLoc=0;
	this.m_mUseNormalTexLoc=0;
	this.m_mUseLightmapLoc=0;
	this.m_mUseReflectTexLoc=0;
	this.m_mUseRefractTexLoc=0;
	this.m_mUsePixelLightingLoc=0;
	this.m_mNumLightsLoc=0;
	this.m_mLightPosLoc=new_number_array(c_Renderer.m_mMaxLights);
	this.m_mLightColorLoc=new_number_array(c_Renderer.m_mMaxLights);
	this.m_mLightRadiusLoc=new_number_array(c_Renderer.m_mMaxLights);
	this.m_mBaseColorLoc=0;
	this.m_mAmbientLoc=0;
	this.m_mShininessLoc=0;
	this.m_mRefractCoefLoc=0;
	this.m_mFogEnabledLoc=0;
	this.m_mFogDistLoc=0;
	this.m_mFogColorLoc=0;
	this.m_mShadowsEnabledLoc=0;
	this.m_mDepthEpsilonLoc=0;
	this.m_mSkinnedLoc=0;
	this.m_mBonesLoc=new_number_array(c_Renderer.m_mMaxBones);
	this.m_mVPosLoc=0;
	this.m_mVNormalLoc=0;
	this.m_mVTangentLoc=0;
	this.m_mVColorLoc=0;
	this.m_mVTexLoc=0;
	this.m_mVTex2Loc=0;
	this.m_mVBoneIndicesLoc=0;
	this.m_mVBoneWeightsLoc=0;
	this.m_mBaseTexSamplerLoc=0;
	this.m_mBaseCubeSamplerLoc=0;
	this.m_mNormalTexSamplerLoc=0;
	this.m_mLightmapSamplerLoc=0;
	this.m_mReflectCubeSamplerLoc=0;
	this.m_mRefractCubeSamplerLoc=0;
	this.m_mDepthSamplerLoc=0;
}
c_GpuProgram.prototype.p_Free=function(){
	gl.deleteProgram(this.m_mProgramId);
}
c_GpuProgram.m_new=function(t_program){
	this.m_mProgramId=t_program;
	gl.useProgram(t_program);
	this.m_mMVPLoc=_glGetUniformLocation(t_program,"mvp");
	this.m_mModelViewLoc=_glGetUniformLocation(t_program,"modelView");
	this.m_mNormalMatrixLoc=_glGetUniformLocation(t_program,"normalMatrix");
	this.m_mInvViewLoc=_glGetUniformLocation(t_program,"invView");
	this.m_mDepthBiasLoc=_glGetUniformLocation(t_program,"depthBias");
	this.m_mBaseTexModeLoc=_glGetUniformLocation(t_program,"baseTexMode");
	this.m_mUseNormalTexLoc=_glGetUniformLocation(t_program,"useNormalTex");
	this.m_mUseLightmapLoc=_glGetUniformLocation(t_program,"useLightmap");
	this.m_mUseReflectTexLoc=_glGetUniformLocation(t_program,"useReflectTex");
	this.m_mUseRefractTexLoc=_glGetUniformLocation(t_program,"useRefractTex");
	this.m_mUsePixelLightingLoc=_glGetUniformLocation(t_program,"usePixelLighting");
	this.m_mNumLightsLoc=_glGetUniformLocation(t_program,"numLights");
	for(var t_i=0;t_i<c_Renderer.m_mMaxLights;t_i=t_i+1){
		this.m_mLightPosLoc[t_i]=_glGetUniformLocation(t_program,"lightPos["+String(t_i)+"]");
		this.m_mLightColorLoc[t_i]=_glGetUniformLocation(t_program,"lightColor["+String(t_i)+"]");
		this.m_mLightRadiusLoc[t_i]=_glGetUniformLocation(t_program,"lightRadius["+String(t_i)+"]");
	}
	this.m_mBaseColorLoc=_glGetUniformLocation(t_program,"baseColor");
	this.m_mAmbientLoc=_glGetUniformLocation(t_program,"ambient");
	this.m_mShininessLoc=_glGetUniformLocation(t_program,"shininess");
	this.m_mRefractCoefLoc=_glGetUniformLocation(t_program,"refractCoef");
	this.m_mFogEnabledLoc=_glGetUniformLocation(t_program,"fogEnabled");
	this.m_mFogDistLoc=_glGetUniformLocation(t_program,"fogDist");
	this.m_mFogColorLoc=_glGetUniformLocation(t_program,"fogColor");
	this.m_mShadowsEnabledLoc=_glGetUniformLocation(t_program,"shadowsEnabled");
	this.m_mDepthEpsilonLoc=_glGetUniformLocation(t_program,"depthEpsilon");
	this.m_mSkinnedLoc=_glGetUniformLocation(t_program,"skinned");
	for(var t_i2=0;t_i2<c_Renderer.m_mMaxBones;t_i2=t_i2+1){
		this.m_mBonesLoc[t_i2]=_glGetUniformLocation(t_program,"bones["+String(t_i2)+"]");
	}
	this.m_mVPosLoc=gl.getAttribLocation(t_program,"vpos");
	this.m_mVNormalLoc=gl.getAttribLocation(t_program,"vnormal");
	this.m_mVTangentLoc=gl.getAttribLocation(t_program,"vtangent");
	this.m_mVColorLoc=gl.getAttribLocation(t_program,"vcolor");
	this.m_mVTexLoc=gl.getAttribLocation(t_program,"vtex");
	this.m_mVTex2Loc=gl.getAttribLocation(t_program,"vtex2");
	this.m_mVBoneIndicesLoc=gl.getAttribLocation(t_program,"vboneIndices");
	this.m_mVBoneWeightsLoc=gl.getAttribLocation(t_program,"vboneWeights");
	this.m_mBaseTexSamplerLoc=_glGetUniformLocation(t_program,"baseTexSampler");
	this.m_mBaseCubeSamplerLoc=_glGetUniformLocation(t_program,"baseCubeSampler");
	this.m_mNormalTexSamplerLoc=_glGetUniformLocation(t_program,"normalTexSampler");
	this.m_mLightmapSamplerLoc=_glGetUniformLocation(t_program,"lightmapSampler");
	this.m_mReflectCubeSamplerLoc=_glGetUniformLocation(t_program,"reflectCubeSampler");
	this.m_mRefractCubeSamplerLoc=_glGetUniformLocation(t_program,"refractCubeSampler");
	this.m_mDepthSamplerLoc=_glGetUniformLocation(t_program,"depthSampler");
	return this;
}
c_GpuProgram.m_new2=function(){
	return this;
}
c_GpuProgram.prototype.p_Use=function(){
	gl.useProgram(this.m_mProgramId);
	if(this.m_mBaseTexSamplerLoc!=-1){
		gl.uniform1i(this.m_mBaseTexSamplerLoc,0);
	}
	if(this.m_mBaseCubeSamplerLoc!=-1){
		gl.uniform1i(this.m_mBaseCubeSamplerLoc,1);
	}
	if(this.m_mNormalTexSamplerLoc!=-1){
		gl.uniform1i(this.m_mNormalTexSamplerLoc,2);
	}
	if(this.m_mLightmapSamplerLoc!=-1){
		gl.uniform1i(this.m_mLightmapSamplerLoc,3);
	}
	if(this.m_mReflectCubeSamplerLoc!=-1){
		gl.uniform1i(this.m_mReflectCubeSamplerLoc,4);
	}
	if(this.m_mRefractCubeSamplerLoc!=-1){
		gl.uniform1i(this.m_mRefractCubeSamplerLoc,5);
	}
	if(this.m_mDepthSamplerLoc!=-1){
		gl.uniform1i(this.m_mDepthSamplerLoc,6);
	}
}
function c_DataBuffer(){
	BBDataBuffer.call(this);
}
c_DataBuffer.prototype=extend_class(BBDataBuffer);
c_DataBuffer.m_new=function(t_length,t_direct){
	if(!this._New(t_length)){
		error("Allocate DataBuffer failed");
	}
	return this;
}
c_DataBuffer.m_new2=function(){
	return this;
}
c_DataBuffer.prototype.p_CopyBytes=function(t_address,t_dst,t_dstaddress,t_count){
	if(t_address+t_count>this.Length()){
		t_count=this.Length()-t_address;
	}
	if(t_dstaddress+t_count>t_dst.Length()){
		t_count=t_dst.Length()-t_dstaddress;
	}
	if(t_dstaddress<=t_address){
		for(var t_i=0;t_i<t_count;t_i=t_i+1){
			t_dst.PokeByte(t_dstaddress+t_i,this.PeekByte(t_address+t_i));
		}
	}else{
		for(var t_i2=t_count-1;t_i2>=0;t_i2=t_i2+-1){
			t_dst.PokeByte(t_dstaddress+t_i2,this.PeekByte(t_address+t_i2));
		}
	}
}
c_DataBuffer.m_Load=function(t_path){
	var t_buf=c_DataBuffer.m_new2.call(new c_DataBuffer);
	if(t_buf._Load(t_path)){
		return t_buf;
	}
	return null;
}
c_DataBuffer.prototype.p_PeekBytes=function(t_address,t_bytes,t_offset,t_count){
	if(t_address+t_count>this.Length()){
		t_count=this.Length()-t_address;
	}
	if(t_offset+t_count>t_bytes.length){
		t_count=t_bytes.length-t_offset;
	}
	for(var t_i=0;t_i<t_count;t_i=t_i+1){
		t_bytes[t_offset+t_i]=this.PeekByte(t_address+t_i);
	}
}
c_DataBuffer.prototype.p_PeekBytes2=function(t_address,t_count){
	if(t_address+t_count>this.Length()){
		t_count=this.Length()-t_address;
	}
	var t_bytes=new_number_array(t_count);
	this.p_PeekBytes(t_address,t_bytes,0,t_count);
	return t_bytes;
}
c_DataBuffer.prototype.p_PeekString=function(t_address,t_count,t_encoding){
	var t_1=t_encoding;
	if(t_1=="utf8"){
		var t_p=this.p_PeekBytes2(t_address,t_count);
		var t_i=0;
		var t_e=t_p.length;
		var t_err=false;
		var t_q=new_number_array(t_e);
		var t_j=0;
		while(t_i<t_e){
			var t_c=t_p[t_i]&255;
			t_i+=1;
			if((t_c&128)!=0){
				if((t_c&224)==192){
					if(t_i>=t_e || (t_p[t_i]&192)!=128){
						t_err=true;
						break;
					}
					t_c=(t_c&31)<<6|t_p[t_i]&63;
					t_i+=1;
				}else{
					if((t_c&240)==224){
						if(t_i+1>=t_e || (t_p[t_i]&192)!=128 || (t_p[t_i+1]&192)!=128){
							t_err=true;
							break;
						}
						t_c=(t_c&15)<<12|(t_p[t_i]&63)<<6|t_p[t_i+1]&63;
						t_i+=2;
					}else{
						t_err=true;
						break;
					}
				}
			}
			t_q[t_j]=t_c;
			t_j+=1;
		}
		if(t_err){
			return string_fromchars(t_p);
		}
		if(t_j<t_e){
			t_q=t_q.slice(0,t_j);
		}
		return string_fromchars(t_q);
	}else{
		if(t_1=="ascii"){
			var t_p2=this.p_PeekBytes2(t_address,t_count);
			for(var t_i2=0;t_i2<t_p2.length;t_i2=t_i2+1){
				t_p2[t_i2]&=255;
			}
			return string_fromchars(t_p2);
		}
	}
	error("Invalid string encoding:"+t_encoding);
	return "";
}
c_DataBuffer.prototype.p_PeekString2=function(t_address,t_encoding){
	return this.p_PeekString(t_address,this.Length()-t_address,t_encoding);
}
function c_Cache(){
	Object.call(this);
	this.m_mFonts=null;
	this.m_mMeshes=null;
	this.m_mTextures=null;
}
c_Cache.m_mStack=[];
c_Cache.m_new=function(){
	this.m_mFonts=c_StringMap.m_new.call(new c_StringMap);
	this.m_mMeshes=c_StringMap2.m_new.call(new c_StringMap2);
	this.m_mTextures=c_StringMap3.m_new.call(new c_StringMap3);
	return this;
}
c_Cache.m_Push=function(){
	c_Cache.m_mStack=resize_object_array(c_Cache.m_mStack,c_Cache.m_mStack.length+1);
	c_Cache.m_mStack[c_Cache.m_mStack.length-1]=c_Cache.m_new.call(new c_Cache);
}
c_Cache.m_LoadTexture=function(t_filename,t_filter){
	for(var t_i=c_Cache.m_mStack.length-1;t_i>=0;t_i=t_i+-1){
		if(c_Cache.m_mStack[t_i].m_mTextures.p_Contains2(t_filename)){
			return c_Cache.m_mStack[t_i].m_mTextures.p_Get(t_filename);
		}
	}
	var t_tex=c_Texture.m__Load(t_filename,t_filter);
	if(t_tex!=null){
		c_Cache.m_mStack[c_Cache.m_mStack.length-1].m_mTextures.p_Set4(t_filename,t_tex);
	}
	return t_tex;
}
c_Cache.m_LoadTexture2=function(t_left,t_right,t_front,t_back,t_top,t_bottom,t_filter){
	var t_filename=t_left+","+t_right+","+t_front+","+t_back+","+t_top+","+t_bottom;
	for(var t_i=c_Cache.m_mStack.length-1;t_i>=0;t_i=t_i+-1){
		if(c_Cache.m_mStack[t_i].m_mTextures.p_Contains2(t_filename)){
			return c_Cache.m_mStack[t_i].m_mTextures.p_Get(t_filename);
		}
	}
	var t_tex=c_Texture.m__Load2(t_left,t_right,t_front,t_back,t_top,t_bottom,t_filter);
	if(t_tex!=null){
		c_Cache.m_mStack[c_Cache.m_mStack.length-1].m_mTextures.p_Set4(t_filename,t_tex);
	}
	return t_tex;
}
c_Cache.m_LoadFont=function(t_filename){
	for(var t_i=c_Cache.m_mStack.length-1;t_i>=0;t_i=t_i+-1){
		if(c_Cache.m_mStack[t_i].m_mFonts.p_Contains2(t_filename)){
			return c_Cache.m_mStack[t_i].m_mFonts.p_Get(t_filename);
		}
	}
	var t_font=c_Font.m__Load(t_filename);
	if(t_font!=null){
		c_Cache.m_mStack[c_Cache.m_mStack.length-1].m_mFonts.p_Set2(t_filename,t_font);
	}
	return t_font;
}
c_Cache.m_LoadMesh=function(t_filename,t_skeletonFilename,t_animationFilename,t_texFilter){
	for(var t_i=c_Cache.m_mStack.length-1;t_i>=0;t_i=t_i+-1){
		if(c_Cache.m_mStack[t_i].m_mMeshes.p_Contains2(t_filename)){
			return c_Cache.m_mStack[t_i].m_mMeshes.p_Get(t_filename);
		}
	}
	var t_mesh=c_Mesh.m__Load(t_filename,t_skeletonFilename,t_animationFilename,t_texFilter);
	if(t_mesh!=null){
		c_Cache.m_mStack[c_Cache.m_mStack.length-1].m_mMeshes.p_Set3(t_filename,t_mesh);
	}
	return t_mesh;
}
function c_Font(){
	Object.call(this);
	this.m_mFilename="";
	this.m_mHeight=.0;
	this.m_mTexture=null;
	this.m_mGlyphs=new_object_array(224);
	this.m_mMaxHeight=.0;
}
c_Font.m_new=function(){
	return this;
}
c_Font.m_Create=function(t_filename,t_height,t_tex){
	var t_f=c_Font.m_new.call(new c_Font);
	t_f.m_mFilename=t_filename;
	t_f.m_mHeight=t_height;
	t_f.m_mTexture=t_tex;
	for(var t_i=0;t_i<t_f.m_mGlyphs.length;t_i=t_i+1){
		t_f.m_mGlyphs[t_i]=c_Glyph.m_new.call(new c_Glyph);
	}
	return t_f;
}
c_Font.prototype.p_SetGlyphData=function(t_index,t_x,t_y,t_w,t_h,t_yoffset){
	this.m_mGlyphs[t_index].m_mX=t_x;
	this.m_mGlyphs[t_index].m_mY=t_y;
	this.m_mGlyphs[t_index].m_mWidth=t_w;
	this.m_mGlyphs[t_index].m_mHeight=t_h;
	this.m_mGlyphs[t_index].m_mYOffset=t_yoffset;
	if(t_index==33 && this.m_mGlyphs[0].m_mWidth==0.0){
		this.m_mGlyphs[0].m_mWidth=t_w;
	}
	if(t_h>this.m_mMaxHeight){
		this.m_mMaxHeight=t_h;
	}
}
c_Font.m__LoadData=function(t_data,t_filename){
	var t_stream=c_DataStream.m_new.call(new c_DataStream,t_data,0);
	var t_id=t_stream.p_ReadString(4,"utf8");
	if(t_id!="FN01"){
		return null;
	}
	var t_texLen=t_stream.p_ReadInt();
	var t_texName=t_stream.p_ReadString(t_texLen,"utf8");
	var t_height=t_stream.p_ReadShort();
	var t_numGlyphs=t_stream.p_ReadInt();
	var t_firstChar=t_stream.p_ReadInt();
	var t_tex=c_Cache.m_LoadTexture(t_texName,0);
	var t_font=c_Font.m_Create(t_filename,(t_height),t_tex);
	for(var t_i=0;t_i<t_numGlyphs;t_i=t_i+1){
		var t_x=t_stream.p_ReadFloat();
		var t_y=t_stream.p_ReadFloat();
		var t_width=t_stream.p_ReadFloat();
		var t_height2=t_stream.p_ReadFloat();
		var t_xoffset=t_stream.p_ReadFloat();
		var t_yoffset=t_stream.p_ReadFloat();
		t_font.p_SetGlyphData(t_i,t_x,t_y,t_width,t_height2,t_yoffset);
	}
	t_stream.p_Close();
	return t_font;
}
c_Font.m__Load=function(t_filename){
	if(t_filename.length>2 && String.fromCharCode(t_filename.charCodeAt(0))!="/" && String.fromCharCode(t_filename.charCodeAt(1))!=":"){
		t_filename="cerberus://data/"+t_filename;
	}
	var t_data=c_DataBuffer.m_Load(t_filename);
	if(!((t_data)!=null)){
		return null;
	}
	var t_font=c_Font.m__LoadData(t_data,t_filename);
	t_data.Discard();
	return t_font;
}
c_Font.prototype.p_TextWidth=function(t_text){
	var t_width=0.0;
	for(var t_i=0;t_i<t_text.length;t_i=t_i+1){
		t_width+=this.m_mGlyphs[t_text.charCodeAt(t_i)-32].m_mWidth;
	}
	return t_width;
}
c_Font.prototype.p_Draw=function(t_x,t_y,t_text){
	var t_textHeight=this.m_mMaxHeight;
	for(var t_i=0;t_i<t_text.length;t_i=t_i+1){
		var t_glyph=this.m_mGlyphs[t_text.charCodeAt(t_i)-32];
		if(t_text.charCodeAt(t_i)-32!=0 && t_glyph.m_mWidth!=0.0 && t_glyph.m_mHeight!=0.0){
			this.m_mTexture.p_Draw2(t_x,t_y+(t_textHeight-t_glyph.m_mHeight)+t_glyph.m_mYOffset,0.0,0.0,t_glyph.m_mX,t_glyph.m_mY,t_glyph.m_mWidth,t_glyph.m_mHeight);
		}
		t_x+=t_glyph.m_mWidth;
	}
}
function c_Map2(){
	Object.call(this);
	this.m_root=null;
}
c_Map2.m_new=function(){
	return this;
}
c_Map2.prototype.p_Compare2=function(t_lhs,t_rhs){
}
c_Map2.prototype.p_FindNode2=function(t_key){
	var t_node=this.m_root;
	while((t_node)!=null){
		var t_cmp=this.p_Compare2(t_key,t_node.m_key);
		if(t_cmp>0){
			t_node=t_node.m_right;
		}else{
			if(t_cmp<0){
				t_node=t_node.m_left;
			}else{
				return t_node;
			}
		}
	}
	return t_node;
}
c_Map2.prototype.p_Contains2=function(t_key){
	return this.p_FindNode2(t_key)!=null;
}
c_Map2.prototype.p_Get=function(t_key){
	var t_node=this.p_FindNode2(t_key);
	if((t_node)!=null){
		return t_node.m_value;
	}
	return null;
}
c_Map2.prototype.p_RotateLeft2=function(t_node){
	var t_child=t_node.m_right;
	t_node.m_right=t_child.m_left;
	if((t_child.m_left)!=null){
		t_child.m_left.m_parent=t_node;
	}
	t_child.m_parent=t_node.m_parent;
	if((t_node.m_parent)!=null){
		if(t_node==t_node.m_parent.m_left){
			t_node.m_parent.m_left=t_child;
		}else{
			t_node.m_parent.m_right=t_child;
		}
	}else{
		this.m_root=t_child;
	}
	t_child.m_left=t_node;
	t_node.m_parent=t_child;
	return 0;
}
c_Map2.prototype.p_RotateRight2=function(t_node){
	var t_child=t_node.m_left;
	t_node.m_left=t_child.m_right;
	if((t_child.m_right)!=null){
		t_child.m_right.m_parent=t_node;
	}
	t_child.m_parent=t_node.m_parent;
	if((t_node.m_parent)!=null){
		if(t_node==t_node.m_parent.m_right){
			t_node.m_parent.m_right=t_child;
		}else{
			t_node.m_parent.m_left=t_child;
		}
	}else{
		this.m_root=t_child;
	}
	t_child.m_right=t_node;
	t_node.m_parent=t_child;
	return 0;
}
c_Map2.prototype.p_InsertFixup2=function(t_node){
	while(((t_node.m_parent)!=null) && t_node.m_parent.m_color==-1 && ((t_node.m_parent.m_parent)!=null)){
		if(t_node.m_parent==t_node.m_parent.m_parent.m_left){
			var t_uncle=t_node.m_parent.m_parent.m_right;
			if(((t_uncle)!=null) && t_uncle.m_color==-1){
				t_node.m_parent.m_color=1;
				t_uncle.m_color=1;
				t_uncle.m_parent.m_color=-1;
				t_node=t_uncle.m_parent;
			}else{
				if(t_node==t_node.m_parent.m_right){
					t_node=t_node.m_parent;
					this.p_RotateLeft2(t_node);
				}
				t_node.m_parent.m_color=1;
				t_node.m_parent.m_parent.m_color=-1;
				this.p_RotateRight2(t_node.m_parent.m_parent);
			}
		}else{
			var t_uncle2=t_node.m_parent.m_parent.m_left;
			if(((t_uncle2)!=null) && t_uncle2.m_color==-1){
				t_node.m_parent.m_color=1;
				t_uncle2.m_color=1;
				t_uncle2.m_parent.m_color=-1;
				t_node=t_uncle2.m_parent;
			}else{
				if(t_node==t_node.m_parent.m_left){
					t_node=t_node.m_parent;
					this.p_RotateRight2(t_node);
				}
				t_node.m_parent.m_color=1;
				t_node.m_parent.m_parent.m_color=-1;
				this.p_RotateLeft2(t_node.m_parent.m_parent);
			}
		}
	}
	this.m_root.m_color=1;
	return 0;
}
c_Map2.prototype.p_Set2=function(t_key,t_value){
	var t_node=this.m_root;
	var t_parent=null;
	var t_cmp=0;
	while((t_node)!=null){
		t_parent=t_node;
		t_cmp=this.p_Compare2(t_key,t_node.m_key);
		if(t_cmp>0){
			t_node=t_node.m_right;
		}else{
			if(t_cmp<0){
				t_node=t_node.m_left;
			}else{
				t_node.m_value=t_value;
				return false;
			}
		}
	}
	t_node=c_Node4.m_new.call(new c_Node4,t_key,t_value,-1,t_parent);
	if((t_parent)!=null){
		if(t_cmp>0){
			t_parent.m_right=t_node;
		}else{
			t_parent.m_left=t_node;
		}
		this.p_InsertFixup2(t_node);
	}else{
		this.m_root=t_node;
	}
	return true;
}
function c_StringMap(){
	c_Map2.call(this);
}
c_StringMap.prototype=extend_class(c_Map2);
c_StringMap.m_new=function(){
	c_Map2.m_new.call(this);
	return this;
}
c_StringMap.prototype.p_Compare2=function(t_lhs,t_rhs){
	return string_compare(t_lhs,t_rhs);
}
function c_Mesh(){
	Object.call(this);
	this.m_mFilename="";
	this.m_mSurfaces=[];
	this.m_mBones=[];
	this.m_mNumFrames=0;
	this.m_mMinBounds=null;
	this.m_mMaxBounds=null;
}
c_Mesh.m_new=function(){
	return this;
}
c_Mesh.m_Create=function(){
	var t_mesh=c_Mesh.m_new.call(new c_Mesh);
	t_mesh.m_mFilename="";
	t_mesh.m_mSurfaces=new_object_array(0);
	t_mesh.m_mBones=new_object_array(0);
	t_mesh.m_mNumFrames=0;
	t_mesh.m_mMinBounds=c_Vec3.m_Create(0.0,0.0,0.0);
	t_mesh.m_mMaxBounds=c_Vec3.m_Create(0.0,0.0,0.0);
	return t_mesh;
}
c_Mesh.m_Create2=function(t_other){
	var t_mesh=c_Mesh.m_Create();
	t_mesh.m_mFilename=t_other.m_mFilename;
	t_mesh.m_mSurfaces=new_object_array(t_other.m_mSurfaces.length);
	for(var t_i=0;t_i<t_other.m_mSurfaces.length;t_i=t_i+1){
		t_mesh.m_mSurfaces[t_i]=c_Surface.m_Create2(t_other.m_mSurfaces[t_i]);
	}
	t_mesh.m_mBones=new_object_array(t_other.m_mBones.length);
	for(var t_i2=0;t_i2<t_other.m_mBones.length;t_i2=t_i2+1){
		t_mesh.m_mBones[t_i2]=c_Bone.m_Create2(t_other.m_mBones[t_i2]);
	}
	t_mesh.m_mNumFrames=t_other.m_mNumFrames;
	t_mesh.m_mMinBounds.p_Set8(t_other.m_mMinBounds);
	t_mesh.m_mMaxBounds.p_Set8(t_other.m_mMaxBounds);
	return t_mesh;
}
c_Mesh.prototype.p_NumSurfaces=function(){
	return this.m_mSurfaces.length;
}
c_Mesh.prototype.p_Surface=function(t_index){
	return this.m_mSurfaces[t_index];
}
c_Mesh.prototype.p_UpdateBounds=function(){
	if(this.p_NumSurfaces()>0 && this.p_Surface(0).p_NumVertices()>0){
		this.m_mMinBounds.p_Set7(this.p_Surface(0).p_VertexX(0),this.p_Surface(0).p_VertexY(0),this.p_Surface(0).p_VertexZ(0));
		this.m_mMaxBounds.p_Set8(this.m_mMinBounds);
		var t_=this.m_mSurfaces;
		var t_2=0;
		while(t_2<t_.length){
			var t_surf=t_[t_2];
			t_2=t_2+1;
			for(var t_index=1;t_index<t_surf.p_NumVertices();t_index=t_index+1){
				var t_vx=t_surf.p_VertexX(t_index);
				var t_vy=t_surf.p_VertexY(t_index);
				var t_vz=t_surf.p_VertexZ(t_index);
				if(t_vx<this.m_mMinBounds.m_X){
					this.m_mMinBounds.m_X=t_vx;
				}
				if(t_vy<this.m_mMinBounds.m_Y){
					this.m_mMinBounds.m_Y=t_vy;
				}
				if(t_vz<this.m_mMinBounds.m_Z){
					this.m_mMinBounds.m_Z=t_vz;
				}
				if(t_vx>this.m_mMaxBounds.m_X){
					this.m_mMaxBounds.m_X=t_vx;
				}
				if(t_vy>this.m_mMaxBounds.m_Y){
					this.m_mMaxBounds.m_Y=t_vy;
				}
				if(t_vz>this.m_mMaxBounds.m_Z){
					this.m_mMaxBounds.m_Z=t_vz;
				}
			}
		}
	}else{
		this.m_mMinBounds.p_Set7(0.0,0.0,0.0);
		this.m_mMaxBounds.p_Set7(0.0,0.0,0.0);
	}
}
c_Mesh.prototype.p_AddSurface=function(t_surf){
	this.m_mSurfaces=resize_object_array(this.m_mSurfaces,this.m_mSurfaces.length+1);
	this.m_mSurfaces[this.m_mSurfaces.length-1]=t_surf;
	this.p_UpdateBounds();
	t_surf.p_Rebuild();
}
c_Mesh.prototype.p_Filename=function(t_filename){
	this.m_mFilename=t_filename;
}
c_Mesh.prototype.p_Filename2=function(){
	return this.m_mFilename;
}
c_Mesh.m__LoadData=function(t_data,t_filename,t_texFilter){
	var t_stream=c_DataStream.m_new.call(new c_DataStream,t_data,0);
	var t_meshPath=bb_filepath_ExtractDir(t_filename);
	if(t_meshPath!=""){
		t_meshPath=t_meshPath+"/";
	}
	var t_id=t_stream.p_ReadString(4,"utf8");
	if(t_id!="ME01"){
		return null;
	}
	var t_mesh=c_Mesh.m_Create();
	t_mesh.p_Filename(t_filename);
	var t_numSurfaces=t_stream.p_ReadShort();
	for(var t_s=0;t_s<t_numSurfaces;t_s=t_s+1){
		var t_surf=c_Surface.m_Create(null);
		var t_flags=0;
		t_surf.p_Material().p_Color(t_stream.p_ReadInt());
		t_surf.p_Material().p_BlendMode(t_stream.p_ReadByte());
		t_flags=t_stream.p_ReadByte();
		if((t_flags&1)!=0){
			t_surf.p_Material().p_Culling(true);
		}else{
			t_surf.p_Material().p_Culling(false);
		}
		if((t_flags&2)!=0){
			t_surf.p_Material().p_DepthWrite2(true);
		}else{
			t_surf.p_Material().p_DepthWrite2(false);
		}
		t_surf.p_Material().p_Shininess(t_stream.p_ReadFloat());
		t_surf.p_Material().p_RefractionCoef(t_stream.p_ReadFloat());
		var t_usedTexs=0;
		t_usedTexs=t_stream.p_ReadByte();
		if((t_usedTexs&1)!=0){
			var t_strLen=t_stream.p_ReadInt();
			var t_str=t_stream.p_ReadString(t_strLen,"utf8");
			if(t_str!=""){
				t_str=t_meshPath+t_str;
			}
			t_surf.p_Material().p_BaseTexture(c_Cache.m_LoadTexture(t_str,t_texFilter));
		}
		if((t_usedTexs&2)!=0){
			var t_strLen2=t_stream.p_ReadInt();
			var t_cubeTexs=t_stream.p_ReadString(t_strLen2,"utf8").split(",");
			for(var t_t=0;t_t<t_cubeTexs.length;t_t=t_t+1){
				if(t_cubeTexs[t_t]!=""){
					t_cubeTexs[t_t]=t_meshPath+t_cubeTexs[t_t];
				}
			}
			t_surf.p_Material().p_BaseTexture(c_Cache.m_LoadTexture2(t_cubeTexs[0],t_cubeTexs[1],t_cubeTexs[2],t_cubeTexs[3],t_cubeTexs[4],t_cubeTexs[5],t_texFilter));
		}
		if((t_usedTexs&4)!=0){
			var t_strLen3=t_stream.p_ReadInt();
			var t_str2=t_stream.p_ReadString(t_strLen3,"utf8");
			if(t_str2!=""){
				t_str2=t_meshPath+t_str2;
			}
			t_surf.p_Material().p_NormalTexture(c_Cache.m_LoadTexture(t_str2,t_texFilter));
		}
		if((t_usedTexs&8)!=0){
			var t_strLen4=t_stream.p_ReadInt();
			var t_str3=t_stream.p_ReadString(t_strLen4,"utf8");
			if(t_str3!=""){
				t_str3=t_meshPath+t_str3;
			}
			t_surf.p_Material().p_LightTexture(c_Cache.m_LoadTexture(t_str3,t_texFilter));
		}
		if((t_usedTexs&16)!=0){
			var t_strLen5=t_stream.p_ReadInt();
			var t_cubeTexs2=t_stream.p_ReadString(t_strLen5,"utf8").split(",");
			for(var t_t2=0;t_t2<t_cubeTexs2.length;t_t2=t_t2+1){
				if(t_cubeTexs2[t_t2]!=""){
					t_cubeTexs2[t_t2]=t_meshPath+t_cubeTexs2[t_t2];
				}
			}
			t_surf.p_Material().p_ReflectionTexture(c_Cache.m_LoadTexture2(t_cubeTexs2[0],t_cubeTexs2[1],t_cubeTexs2[2],t_cubeTexs2[3],t_cubeTexs2[4],t_cubeTexs2[5],t_texFilter));
		}
		if((t_usedTexs&32)!=0){
			var t_strLen6=t_stream.p_ReadInt();
			var t_cubeTexs3=t_stream.p_ReadString(t_strLen6,"utf8").split(",");
			for(var t_t3=0;t_t3<t_cubeTexs3.length;t_t3=t_t3+1){
				if(t_cubeTexs3[t_t3]!=""){
					t_cubeTexs3[t_t3]=t_meshPath+t_cubeTexs3[t_t3];
				}
			}
			t_surf.p_Material().p_RefractionTexture(c_Cache.m_LoadTexture2(t_cubeTexs3[0],t_cubeTexs3[1],t_cubeTexs3[2],t_cubeTexs3[3],t_cubeTexs3[4],t_cubeTexs3[5],t_texFilter));
		}
		var t_numIndices=t_stream.p_ReadInt();
		var t_numVertices=t_stream.p_ReadShort();
		var t_vertexFlags=t_stream.p_ReadByte();
		for(var t_i=0;t_i<t_numIndices;t_i=t_i+3){
			var t_v0=t_stream.p_ReadShort();
			var t_v1=t_stream.p_ReadShort();
			var t_v2=t_stream.p_ReadShort();
			t_surf.p_AddTriangle(t_v0,t_v1,t_v2);
		}
		for(var t_v=0;t_v<t_numVertices;t_v=t_v+1){
			var t_x=t_stream.p_ReadFloat();
			var t_y=t_stream.p_ReadFloat();
			var t_z=t_stream.p_ReadFloat();
			var t_nx=0.0;
			var t_ny=0.0;
			var t_nz=0.0;
			if((t_vertexFlags&1)==1){
				t_nx=t_stream.p_ReadFloat();
				t_ny=t_stream.p_ReadFloat();
				t_nz=t_stream.p_ReadFloat();
			}
			var t_tx=0.0;
			var t_ty=0.0;
			var t_tz=0.0;
			if((t_vertexFlags&2)==2){
				t_tx=t_stream.p_ReadFloat();
				t_ty=t_stream.p_ReadFloat();
				t_tz=t_stream.p_ReadFloat();
			}
			var t_color=-1;
			if((t_vertexFlags&4)==4){
				t_color=t_stream.p_ReadInt();
			}
			var t_u0=0.0;
			var t_v02=0.0;
			if((t_vertexFlags&8)==8){
				t_u0=t_stream.p_ReadFloat();
				t_v02=t_stream.p_ReadFloat();
			}
			var t_u1=t_u0;
			var t_v12=t_v02;
			if((t_vertexFlags&16)==16){
				t_u1=t_stream.p_ReadFloat();
				t_v12=t_stream.p_ReadFloat();
			}
			var t_b0=-1;
			var t_b1=-1;
			var t_b2=-1;
			var t_b3=-1;
			var t_w0=0.0;
			var t_w1=0.0;
			var t_w2=0.0;
			var t_w3=0.0;
			if((t_vertexFlags&32)==32){
				t_b0=t_stream.p_ReadShort();
				t_b1=t_stream.p_ReadShort();
				t_b2=t_stream.p_ReadShort();
				t_b3=t_stream.p_ReadShort();
				t_w0=t_stream.p_ReadFloat();
				t_w1=t_stream.p_ReadFloat();
				t_w2=t_stream.p_ReadFloat();
				t_w3=t_stream.p_ReadFloat();
			}
			t_surf.p_AddVertex(t_x,t_y,t_z,t_nx,t_ny,t_nz,t_color,t_u0,t_v02);
			t_surf.p_SetVertexTangent(t_v,t_tx,t_ty,t_tz);
			t_surf.p_SetVertexTexCoords(t_v,t_u1,t_v12,1);
			t_surf.p_SetVertexBone(t_v,0,t_b0,t_w0);
			t_surf.p_SetVertexBone(t_v,1,t_b1,t_w1);
			t_surf.p_SetVertexBone(t_v,2,t_b2,t_w2);
			t_surf.p_SetVertexBone(t_v,3,t_b3,t_w3);
		}
		t_mesh.p_AddSurface(t_surf);
	}
	t_stream.p_Close();
	t_mesh.p_UpdateBounds();
	return t_mesh;
}
c_Mesh.m_mTempMatrix=null;
c_Mesh.prototype.p_AddBone=function(t_bone){
	this.m_mBones=resize_object_array(this.m_mBones,this.m_mBones.length+1);
	this.m_mBones[this.m_mBones.length-1]=t_bone;
}
c_Mesh.prototype.p_LoadSkeletonData=function(t_data){
	var t_stream=c_DataStream.m_new.call(new c_DataStream,t_data,0);
	var t_id=t_stream.p_ReadString(4,"utf8");
	if(t_id!="SK01"){
		return false;
	}
	var t_numBones=t_stream.p_ReadShort();
	for(var t_b=0;t_b<t_numBones;t_b=t_b+1){
		var t_nameLen=t_stream.p_ReadInt();
		var t_name=t_stream.p_ReadString(t_nameLen,"utf8");
		var t_parentIndex=t_stream.p_ReadInt();
		for(var t_i=0;t_i<16;t_i=t_i+1){
			c_Mesh.m_mTempMatrix.m_M[t_i]=t_stream.p_ReadFloat();
		}
		var t_bone=c_Bone.m_Create(t_name,t_parentIndex);
		t_bone.p_InversePoseMatrix(c_Mesh.m_mTempMatrix);
		this.p_AddBone(t_bone);
	}
	return true;
}
c_Mesh.prototype.p_NumFrames=function(t_numFrames){
	this.m_mNumFrames=t_numFrames;
}
c_Mesh.prototype.p_NumFrames2=function(){
	return this.m_mNumFrames;
}
c_Mesh.prototype.p_Bone=function(t_index){
	if(t_index==-1){
		return null;
	}
	return this.m_mBones[t_index];
}
c_Mesh.prototype.p_LoadAnimationData=function(t_data){
	var t_stream=c_DataStream.m_new.call(new c_DataStream,t_data,0);
	var t_id=t_stream.p_ReadString(4,"utf8");
	if(t_id!="AN01"){
		return false;
	}
	var t_numFrames=t_stream.p_ReadShort();
	var t_numBones=t_stream.p_ReadShort();
	var t_firstFrame=this.p_NumFrames2();
	for(var t_i=0;t_i<t_numBones;t_i=t_i+1){
		var t_numKeys=t_stream.p_ReadShort();
		for(var t_k=0;t_k<t_numKeys;t_k=t_k+1){
			var t_frame=t_stream.p_ReadShort();
			var t_x=t_stream.p_ReadFloat();
			var t_y=t_stream.p_ReadFloat();
			var t_z=t_stream.p_ReadFloat();
			this.p_Bone(t_i).p_AddPositionKey(t_firstFrame+t_frame,t_x,t_y,t_z);
		}
		t_numKeys=t_stream.p_ReadShort();
		for(var t_k2=0;t_k2<t_numKeys;t_k2=t_k2+1){
			var t_frame2=t_stream.p_ReadShort();
			var t_w=t_stream.p_ReadFloat();
			var t_x2=t_stream.p_ReadFloat();
			var t_y2=t_stream.p_ReadFloat();
			var t_z2=t_stream.p_ReadFloat();
			this.p_Bone(t_i).p_AddRotationKey(t_firstFrame+t_frame2,t_w,t_x2,t_y2,t_z2);
		}
		t_numKeys=t_stream.p_ReadShort();
		for(var t_k3=0;t_k3<t_numKeys;t_k3=t_k3+1){
			var t_frame3=t_stream.p_ReadShort();
			var t_x3=t_stream.p_ReadFloat();
			var t_y3=t_stream.p_ReadFloat();
			var t_z3=t_stream.p_ReadFloat();
			this.p_Bone(t_i).p_AddScaleKey(t_firstFrame+t_frame3,t_x3,t_y3,t_z3);
		}
	}
	this.p_NumFrames(this.p_NumFrames2()+t_numFrames);
	return true;
}
c_Mesh.m__Load=function(t_filename,t_skeletonFilename,t_animationFilename,t_texFilter){
	var t_fixedFilename=t_filename;
	var t_fixedSkeletonFilename=t_skeletonFilename;
	var t_fixedAnimationFilename=t_animationFilename;
	if(t_filename.length>2 && String.fromCharCode(t_filename.charCodeAt(0))!="/" && String.fromCharCode(t_filename.charCodeAt(1))!=":"){
		t_fixedFilename="cerberus://data/"+t_filename;
	}
	if(t_skeletonFilename.length>2 && String.fromCharCode(t_skeletonFilename.charCodeAt(0))!="/" && String.fromCharCode(t_skeletonFilename.charCodeAt(1))!=":"){
		t_fixedSkeletonFilename="cerberus://data/"+t_skeletonFilename;
	}
	if(t_animationFilename.length>2 && String.fromCharCode(t_animationFilename.charCodeAt(0))!="/" && String.fromCharCode(t_animationFilename.charCodeAt(1))!=":"){
		t_fixedAnimationFilename="cerberus://data/"+t_animationFilename;
	}
	var t_data=c_DataBuffer.m_Load(t_fixedFilename);
	if(!((t_data)!=null)){
		return null;
	}
	var t_mesh=c_Mesh.m__LoadData(t_data,t_filename,t_texFilter);
	t_data.Discard();
	t_data=c_DataBuffer.m_Load(t_fixedSkeletonFilename);
	if((t_data)!=null){
		t_mesh.p_LoadSkeletonData(t_data);
		t_data.Discard();
	}
	t_data=c_DataBuffer.m_Load(t_fixedAnimationFilename);
	if((t_data)!=null){
		t_mesh.p_LoadAnimationData(t_data);
		t_data.Discard();
	}
	return t_mesh;
}
c_Mesh.prototype.p_NumBones=function(){
	return this.m_mBones.length;
}
c_Mesh.prototype.p_Animate=function(t_animMatrices,t_frame,t_firstFrame,t_lastFrame){
	if(this.m_mBones.length>0){
		if(t_lastFrame==0){
			t_lastFrame=this.m_mNumFrames;
		}
		for(var t_i=0;t_i<this.p_NumBones();t_i=t_i+1){
			var t_parentIndex=this.p_Bone(t_i).p_ParentIndex();
			if(t_parentIndex>-1){
				t_animMatrices[t_i].p_Set9(t_animMatrices[t_parentIndex]);
				this.p_Bone(t_i).p_CalculateAnimMatrix(c_Mesh.m_mTempMatrix,t_frame,t_firstFrame,t_lastFrame);
				t_animMatrices[t_i].p_Mul6(c_Mesh.m_mTempMatrix);
			}else{
				this.p_Bone(t_i).p_CalculateAnimMatrix(t_animMatrices[t_i],t_frame,t_firstFrame,t_lastFrame);
			}
		}
		for(var t_i2=0;t_i2<this.p_NumBones();t_i2=t_i2+1){
			t_animMatrices[t_i2].p_Mul6(this.p_Bone(t_i2).p_InversePoseMatrix2());
		}
	}
}
function c_Map3(){
	Object.call(this);
	this.m_root=null;
}
c_Map3.m_new=function(){
	return this;
}
c_Map3.prototype.p_Compare2=function(t_lhs,t_rhs){
}
c_Map3.prototype.p_FindNode2=function(t_key){
	var t_node=this.m_root;
	while((t_node)!=null){
		var t_cmp=this.p_Compare2(t_key,t_node.m_key);
		if(t_cmp>0){
			t_node=t_node.m_right;
		}else{
			if(t_cmp<0){
				t_node=t_node.m_left;
			}else{
				return t_node;
			}
		}
	}
	return t_node;
}
c_Map3.prototype.p_Contains2=function(t_key){
	return this.p_FindNode2(t_key)!=null;
}
c_Map3.prototype.p_Get=function(t_key){
	var t_node=this.p_FindNode2(t_key);
	if((t_node)!=null){
		return t_node.m_value;
	}
	return null;
}
c_Map3.prototype.p_RotateLeft3=function(t_node){
	var t_child=t_node.m_right;
	t_node.m_right=t_child.m_left;
	if((t_child.m_left)!=null){
		t_child.m_left.m_parent=t_node;
	}
	t_child.m_parent=t_node.m_parent;
	if((t_node.m_parent)!=null){
		if(t_node==t_node.m_parent.m_left){
			t_node.m_parent.m_left=t_child;
		}else{
			t_node.m_parent.m_right=t_child;
		}
	}else{
		this.m_root=t_child;
	}
	t_child.m_left=t_node;
	t_node.m_parent=t_child;
	return 0;
}
c_Map3.prototype.p_RotateRight3=function(t_node){
	var t_child=t_node.m_left;
	t_node.m_left=t_child.m_right;
	if((t_child.m_right)!=null){
		t_child.m_right.m_parent=t_node;
	}
	t_child.m_parent=t_node.m_parent;
	if((t_node.m_parent)!=null){
		if(t_node==t_node.m_parent.m_right){
			t_node.m_parent.m_right=t_child;
		}else{
			t_node.m_parent.m_left=t_child;
		}
	}else{
		this.m_root=t_child;
	}
	t_child.m_right=t_node;
	t_node.m_parent=t_child;
	return 0;
}
c_Map3.prototype.p_InsertFixup3=function(t_node){
	while(((t_node.m_parent)!=null) && t_node.m_parent.m_color==-1 && ((t_node.m_parent.m_parent)!=null)){
		if(t_node.m_parent==t_node.m_parent.m_parent.m_left){
			var t_uncle=t_node.m_parent.m_parent.m_right;
			if(((t_uncle)!=null) && t_uncle.m_color==-1){
				t_node.m_parent.m_color=1;
				t_uncle.m_color=1;
				t_uncle.m_parent.m_color=-1;
				t_node=t_uncle.m_parent;
			}else{
				if(t_node==t_node.m_parent.m_right){
					t_node=t_node.m_parent;
					this.p_RotateLeft3(t_node);
				}
				t_node.m_parent.m_color=1;
				t_node.m_parent.m_parent.m_color=-1;
				this.p_RotateRight3(t_node.m_parent.m_parent);
			}
		}else{
			var t_uncle2=t_node.m_parent.m_parent.m_left;
			if(((t_uncle2)!=null) && t_uncle2.m_color==-1){
				t_node.m_parent.m_color=1;
				t_uncle2.m_color=1;
				t_uncle2.m_parent.m_color=-1;
				t_node=t_uncle2.m_parent;
			}else{
				if(t_node==t_node.m_parent.m_left){
					t_node=t_node.m_parent;
					this.p_RotateRight3(t_node);
				}
				t_node.m_parent.m_color=1;
				t_node.m_parent.m_parent.m_color=-1;
				this.p_RotateLeft3(t_node.m_parent.m_parent);
			}
		}
	}
	this.m_root.m_color=1;
	return 0;
}
c_Map3.prototype.p_Set3=function(t_key,t_value){
	var t_node=this.m_root;
	var t_parent=null;
	var t_cmp=0;
	while((t_node)!=null){
		t_parent=t_node;
		t_cmp=this.p_Compare2(t_key,t_node.m_key);
		if(t_cmp>0){
			t_node=t_node.m_right;
		}else{
			if(t_cmp<0){
				t_node=t_node.m_left;
			}else{
				t_node.m_value=t_value;
				return false;
			}
		}
	}
	t_node=c_Node8.m_new.call(new c_Node8,t_key,t_value,-1,t_parent);
	if((t_parent)!=null){
		if(t_cmp>0){
			t_parent.m_right=t_node;
		}else{
			t_parent.m_left=t_node;
		}
		this.p_InsertFixup3(t_node);
	}else{
		this.m_root=t_node;
	}
	return true;
}
function c_StringMap2(){
	c_Map3.call(this);
}
c_StringMap2.prototype=extend_class(c_Map3);
c_StringMap2.m_new=function(){
	c_Map3.m_new.call(this);
	return this;
}
c_StringMap2.prototype.p_Compare2=function(t_lhs,t_rhs){
	return string_compare(t_lhs,t_rhs);
}
function c_Texture(){
	Object.call(this);
	this.m_mHandle=0;
	this.m_mWidth=0;
	this.m_mHeight=0;
	this.m_mIsCubic=false;
	this.m_mFilename="";
}
c_Texture.m_new=function(){
	return this;
}
c_Texture.m_Create=function(t_width,t_height){
	var t_tex=c_Texture.m_new.call(new c_Texture);
	t_tex.m_mHandle=c_Renderer.m_CreateTexture(t_width,t_height);
	t_tex.m_mWidth=t_width;
	t_tex.m_mHeight=t_height;
	t_tex.m_mIsCubic=false;
	return t_tex;
}
c_Texture.m_Create2=function(t_buffer,t_width,t_height,t_filter){
	var t_tex=c_Texture.m_new.call(new c_Texture);
	t_tex.m_mHandle=c_Renderer.m_CreateTexture2(t_buffer,t_width,t_height,t_filter);
	t_tex.m_mWidth=t_width;
	t_tex.m_mHeight=t_height;
	t_tex.m_mIsCubic=false;
	return t_tex;
}
c_Texture.prototype.p_Handle=function(){
	return this.m_mHandle;
}
c_Texture.m_mSizeArr=[];
c_Texture.m__Load=function(t_filename,t_filter){
	t_filename=string_replace(t_filename,"\\","/");
	var t_handle=c_Renderer.m_LoadTexture(t_filename,c_Texture.m_mSizeArr,t_filter);
	if(c_Texture.m_mSizeArr[0]>0){
		var t_tex=c_Texture.m_new.call(new c_Texture);
		t_tex.m_mFilename=t_filename;
		t_tex.m_mHandle=t_handle;
		t_tex.m_mWidth=c_Texture.m_mSizeArr[0];
		t_tex.m_mHeight=c_Texture.m_mSizeArr[1];
		t_tex.m_mIsCubic=false;
		return t_tex;
	}else{
		return null;
	}
}
c_Texture.m__Load2=function(t_left,t_right,t_front,t_back,t_top,t_bottom,t_filter){
	t_left=string_replace(t_left,"\\","/");
	t_right=string_replace(t_right,"\\","/");
	t_front=string_replace(t_front,"\\","/");
	t_back=string_replace(t_back,"\\","/");
	t_top=string_replace(t_top,"\\","/");
	t_bottom=string_replace(t_bottom,"\\","/");
	var t_handle=c_Renderer.m_LoadCubicTexture(t_left,t_right,t_front,t_back,t_top,t_bottom,c_Texture.m_mSizeArr,t_filter);
	if(c_Texture.m_mSizeArr[0]>0){
		var t_tex=c_Texture.m_new.call(new c_Texture);
		t_tex.m_mFilename=t_left+","+t_right+","+t_front+","+t_back+","+t_top+","+t_bottom;
		t_tex.m_mHandle=t_handle;
		t_tex.m_mWidth=c_Texture.m_mSizeArr[0];
		t_tex.m_mHeight=c_Texture.m_mSizeArr[1];
		t_tex.m_mIsCubic=true;
		return t_tex;
	}else{
		return null;
	}
}
c_Texture.prototype.p_Width=function(){
	return this.m_mWidth;
}
c_Texture.prototype.p_Height=function(){
	return this.m_mHeight;
}
c_Texture.prototype.p_IsCubic=function(){
	return this.m_mIsCubic;
}
c_Texture.prototype.p_Draw2=function(t_x,t_y,t_width,t_height,t_rectx,t_recty,t_rectwidth,t_rectheight){
	if(t_rectwidth==0.0){
		t_rectwidth=(this.p_Width());
	}
	if(t_rectheight==0.0){
		t_rectheight=(this.p_Height());
	}
	if(t_width==0.0){
		t_width=t_rectwidth;
	}
	if(t_height==0.0){
		t_height=t_rectheight;
	}
	var t_u0=t_rectx/(this.p_Width())*bb_math_Sgn2(t_width);
	var t_v0=t_recty/(this.p_Height())*bb_math_Sgn2(t_height);
	var t_u1=(t_rectx+t_rectwidth)/(this.p_Width())*bb_math_Sgn2(t_width);
	var t_v1=(t_recty+t_rectheight)/(this.p_Height())*bb_math_Sgn2(t_height);
	c_Renderer.m_SetTextures(this.m_mHandle,0,0,0,0,this.m_mIsCubic);
	c_Renderer.m_DrawRectEx(t_x,t_y,bb_math_Abs2(t_width),bb_math_Abs2(t_height),t_u0,t_v0,t_u1,t_v1);
	c_Renderer.m_SetTextures(0,0,0,0,0,false);
}
function c_Map4(){
	Object.call(this);
	this.m_root=null;
}
c_Map4.m_new=function(){
	return this;
}
c_Map4.prototype.p_Compare2=function(t_lhs,t_rhs){
}
c_Map4.prototype.p_FindNode2=function(t_key){
	var t_node=this.m_root;
	while((t_node)!=null){
		var t_cmp=this.p_Compare2(t_key,t_node.m_key);
		if(t_cmp>0){
			t_node=t_node.m_right;
		}else{
			if(t_cmp<0){
				t_node=t_node.m_left;
			}else{
				return t_node;
			}
		}
	}
	return t_node;
}
c_Map4.prototype.p_Contains2=function(t_key){
	return this.p_FindNode2(t_key)!=null;
}
c_Map4.prototype.p_Get=function(t_key){
	var t_node=this.p_FindNode2(t_key);
	if((t_node)!=null){
		return t_node.m_value;
	}
	return null;
}
c_Map4.prototype.p_RotateLeft4=function(t_node){
	var t_child=t_node.m_right;
	t_node.m_right=t_child.m_left;
	if((t_child.m_left)!=null){
		t_child.m_left.m_parent=t_node;
	}
	t_child.m_parent=t_node.m_parent;
	if((t_node.m_parent)!=null){
		if(t_node==t_node.m_parent.m_left){
			t_node.m_parent.m_left=t_child;
		}else{
			t_node.m_parent.m_right=t_child;
		}
	}else{
		this.m_root=t_child;
	}
	t_child.m_left=t_node;
	t_node.m_parent=t_child;
	return 0;
}
c_Map4.prototype.p_RotateRight4=function(t_node){
	var t_child=t_node.m_left;
	t_node.m_left=t_child.m_right;
	if((t_child.m_right)!=null){
		t_child.m_right.m_parent=t_node;
	}
	t_child.m_parent=t_node.m_parent;
	if((t_node.m_parent)!=null){
		if(t_node==t_node.m_parent.m_right){
			t_node.m_parent.m_right=t_child;
		}else{
			t_node.m_parent.m_left=t_child;
		}
	}else{
		this.m_root=t_child;
	}
	t_child.m_right=t_node;
	t_node.m_parent=t_child;
	return 0;
}
c_Map4.prototype.p_InsertFixup4=function(t_node){
	while(((t_node.m_parent)!=null) && t_node.m_parent.m_color==-1 && ((t_node.m_parent.m_parent)!=null)){
		if(t_node.m_parent==t_node.m_parent.m_parent.m_left){
			var t_uncle=t_node.m_parent.m_parent.m_right;
			if(((t_uncle)!=null) && t_uncle.m_color==-1){
				t_node.m_parent.m_color=1;
				t_uncle.m_color=1;
				t_uncle.m_parent.m_color=-1;
				t_node=t_uncle.m_parent;
			}else{
				if(t_node==t_node.m_parent.m_right){
					t_node=t_node.m_parent;
					this.p_RotateLeft4(t_node);
				}
				t_node.m_parent.m_color=1;
				t_node.m_parent.m_parent.m_color=-1;
				this.p_RotateRight4(t_node.m_parent.m_parent);
			}
		}else{
			var t_uncle2=t_node.m_parent.m_parent.m_left;
			if(((t_uncle2)!=null) && t_uncle2.m_color==-1){
				t_node.m_parent.m_color=1;
				t_uncle2.m_color=1;
				t_uncle2.m_parent.m_color=-1;
				t_node=t_uncle2.m_parent;
			}else{
				if(t_node==t_node.m_parent.m_left){
					t_node=t_node.m_parent;
					this.p_RotateRight4(t_node);
				}
				t_node.m_parent.m_color=1;
				t_node.m_parent.m_parent.m_color=-1;
				this.p_RotateLeft4(t_node.m_parent.m_parent);
			}
		}
	}
	this.m_root.m_color=1;
	return 0;
}
c_Map4.prototype.p_Set4=function(t_key,t_value){
	var t_node=this.m_root;
	var t_parent=null;
	var t_cmp=0;
	while((t_node)!=null){
		t_parent=t_node;
		t_cmp=this.p_Compare2(t_key,t_node.m_key);
		if(t_cmp>0){
			t_node=t_node.m_right;
		}else{
			if(t_cmp<0){
				t_node=t_node.m_left;
			}else{
				t_node.m_value=t_value;
				return false;
			}
		}
	}
	t_node=c_Node5.m_new.call(new c_Node5,t_key,t_value,-1,t_parent);
	if((t_parent)!=null){
		if(t_cmp>0){
			t_parent.m_right=t_node;
		}else{
			t_parent.m_left=t_node;
		}
		this.p_InsertFixup4(t_node);
	}else{
		this.m_root=t_node;
	}
	return true;
}
function c_StringMap3(){
	c_Map4.call(this);
}
c_StringMap3.prototype=extend_class(c_Map4);
c_StringMap3.m_new=function(){
	c_Map4.m_new.call(this);
	return this;
}
c_StringMap3.prototype.p_Compare2=function(t_lhs,t_rhs){
	return string_compare(t_lhs,t_rhs);
}
function c_Stats(){
	Object.call(this);
}
c_Stats.m_mLastMillisecs=0;
c_Stats.m_mFpsCounter=0;
c_Stats.m_mFpsAccum=0;
c_Stats.m__Init=function(){
	c_Stats.m_mLastMillisecs=bb_app_Millisecs();
	c_Stats.m_mFpsCounter=0;
	c_Stats.m_mFpsAccum=0.0;
}
c_Stats.m_ShaderError=function(){
	return c_Renderer.m_ProgramError();
}
c_Stats.m_VendorName=function(){
	return c_Renderer.m_VendorName();
}
c_Stats.m_RendererName=function(){
	return c_Renderer.m_RendererName();
}
c_Stats.m_APIVersionName=function(){
	return c_Renderer.m_APIVersionName();
}
c_Stats.m_ShadingVersionName=function(){
	return c_Renderer.m_ShadingVersionName();
}
c_Stats.m_mDeltaTime=0;
c_Stats.m__UpdateDeltaTime=function(){
	c_Stats.m_mDeltaTime=(bb_app_Millisecs()-c_Stats.m_mLastMillisecs)/1000.0;
	c_Stats.m_mLastMillisecs=bb_app_Millisecs();
}
c_Stats.m_DeltaTime=function(){
	return c_Stats.m_mDeltaTime;
}
c_Stats.m_mFps=0;
c_Stats.m__UpdateFPS=function(){
	c_Stats.m_mFpsCounter+=1;
	c_Stats.m_mFpsAccum+=c_Stats.m_mDeltaTime;
	if(c_Stats.m_mFpsAccum>=1.0){
		c_Stats.m_mFps=c_Stats.m_mFpsCounter;
		c_Stats.m_mFpsCounter=0;
		c_Stats.m_mFpsAccum=0.0;
	}
}
c_Stats.m_mRenderCalls=0;
c_Stats.m__SetRenderCalls=function(t_num){
	c_Stats.m_mRenderCalls=t_num;
}
c_Stats.m_RenderCalls=function(){
	return c_Stats.m_mRenderCalls;
}
function c_Primitive(){
	Object.call(this);
}
c_Primitive.m_CreateSkybox=function(){
	var t_surf=c_Surface.m_Create(null);
	t_surf.p_AddVertex(-0.5,0.5,-0.5,0.0,0.0,1.0,-1,0.0,0.0);
	t_surf.p_SetVertexTangent(t_surf.p_NumVertices()-1,-1.0,0.0,0.0);
	t_surf.p_AddVertex(0.5,0.5,-0.5,0.0,0.0,1.0,-1,1.0,0.0);
	t_surf.p_SetVertexTangent(t_surf.p_NumVertices()-1,-1.0,0.0,0.0);
	t_surf.p_AddVertex(-0.5,-0.5,-0.5,0.0,0.0,1.0,-1,0.0,1.0);
	t_surf.p_SetVertexTangent(t_surf.p_NumVertices()-1,-1.0,0.0,0.0);
	t_surf.p_AddVertex(0.5,-0.5,-0.5,0.0,0.0,1.0,-1,1.0,1.0);
	t_surf.p_SetVertexTangent(t_surf.p_NumVertices()-1,-1.0,0.0,0.0);
	t_surf.p_AddTriangle(0,2,1);
	t_surf.p_AddTriangle(3,1,2);
	t_surf.p_AddVertex(0.5,0.5,0.5,0.0,0.0,-1.0,-1,0.0,0.0);
	t_surf.p_SetVertexTangent(t_surf.p_NumVertices()-1,1.0,0.0,0.0);
	t_surf.p_AddVertex(-0.5,0.5,0.5,0.0,0.0,-1.0,-1,1.0,0.0);
	t_surf.p_SetVertexTangent(t_surf.p_NumVertices()-1,1.0,0.0,0.0);
	t_surf.p_AddVertex(0.5,-0.5,0.5,0.0,0.0,-1.0,-1,0.0,1.0);
	t_surf.p_SetVertexTangent(t_surf.p_NumVertices()-1,1.0,0.0,0.0);
	t_surf.p_AddVertex(-0.5,-0.5,0.5,0.0,0.0,-1.0,-1,1.0,1.0);
	t_surf.p_SetVertexTangent(t_surf.p_NumVertices()-1,1.0,0.0,0.0);
	t_surf.p_AddTriangle(4,6,5);
	t_surf.p_AddTriangle(7,5,6);
	t_surf.p_AddVertex(-0.5,0.5,0.5,1.0,0.0,0.0,-1,0.0,0.0);
	t_surf.p_SetVertexTangent(t_surf.p_NumVertices()-1,0.0,0.0,1.0);
	t_surf.p_AddVertex(-0.5,0.5,-0.5,1.0,0.0,0.0,-1,1.0,0.0);
	t_surf.p_SetVertexTangent(t_surf.p_NumVertices()-1,0.0,0.0,1.0);
	t_surf.p_AddVertex(-0.5,-0.5,0.5,1.0,0.0,0.0,-1,0.0,1.0);
	t_surf.p_SetVertexTangent(t_surf.p_NumVertices()-1,0.0,0.0,1.0);
	t_surf.p_AddVertex(-0.5,-0.5,-0.5,1.0,0.0,0.0,-1,1.0,1.0);
	t_surf.p_SetVertexTangent(t_surf.p_NumVertices()-1,0.0,0.0,1.0);
	t_surf.p_AddTriangle(8,10,9);
	t_surf.p_AddTriangle(11,9,10);
	t_surf.p_AddVertex(0.5,0.5,-0.5,-1.0,0.0,0.0,-1,0.0,0.0);
	t_surf.p_SetVertexTangent(t_surf.p_NumVertices()-1,0.0,0.0,-1.0);
	t_surf.p_AddVertex(0.5,0.5,0.5,-1.0,0.0,0.0,-1,1.0,0.0);
	t_surf.p_SetVertexTangent(t_surf.p_NumVertices()-1,0.0,0.0,-1.0);
	t_surf.p_AddVertex(0.5,-0.5,-0.5,-1.0,0.0,0.0,-1,0.0,1.0);
	t_surf.p_SetVertexTangent(t_surf.p_NumVertices()-1,0.0,0.0,-1.0);
	t_surf.p_AddVertex(0.5,-0.5,0.5,-1.0,0.0,0.0,-1,1.0,1.0);
	t_surf.p_SetVertexTangent(t_surf.p_NumVertices()-1,0.0,0.0,-1.0);
	t_surf.p_AddTriangle(12,14,13);
	t_surf.p_AddTriangle(15,13,14);
	t_surf.p_AddVertex(-0.5,0.5,0.5,0.0,-1.0,0.0,-1,0.0,0.0);
	t_surf.p_SetVertexTangent(t_surf.p_NumVertices()-1,1.0,0.0,0.0);
	t_surf.p_AddVertex(0.5,0.5,0.5,0.0,-1.0,0.0,-1,1.0,0.0);
	t_surf.p_SetVertexTangent(t_surf.p_NumVertices()-1,1.0,0.0,0.0);
	t_surf.p_AddVertex(-0.5,0.5,-0.5,0.0,-1.0,0.0,-1,0.0,1.0);
	t_surf.p_SetVertexTangent(t_surf.p_NumVertices()-1,1.0,0.0,0.0);
	t_surf.p_AddVertex(0.5,0.5,-0.5,0.0,-1.0,0.0,-1,1.0,1.0);
	t_surf.p_SetVertexTangent(t_surf.p_NumVertices()-1,1.0,0.0,0.0);
	t_surf.p_AddTriangle(16,18,17);
	t_surf.p_AddTriangle(19,17,18);
	t_surf.p_AddVertex(-0.5,-0.5,-0.5,0.0,1.0,0.0,-1,0.0,0.0);
	t_surf.p_SetVertexTangent(t_surf.p_NumVertices()-1,1.0,0.0,0.0);
	t_surf.p_AddVertex(0.5,-0.5,-0.5,0.0,1.0,0.0,-1,1.0,0.0);
	t_surf.p_SetVertexTangent(t_surf.p_NumVertices()-1,1.0,0.0,0.0);
	t_surf.p_AddVertex(-0.5,-0.5,0.5,0.0,1.0,0.0,-1,0.0,1.0);
	t_surf.p_SetVertexTangent(t_surf.p_NumVertices()-1,1.0,0.0,0.0);
	t_surf.p_AddVertex(0.5,-0.5,0.5,0.0,1.0,0.0,-1,1.0,1.0);
	t_surf.p_SetVertexTangent(t_surf.p_NumVertices()-1,1.0,0.0,0.0);
	t_surf.p_AddTriangle(20,22,21);
	t_surf.p_AddTriangle(23,21,22);
	var t_skybox=c_Mesh.m_Create();
	t_skybox.p_AddSurface(t_surf);
	t_skybox.p_UpdateBounds();
	return t_skybox;
}
function c_Surface(){
	Object.call(this);
	this.m_mMaterial=null;
	this.m_mIndices=null;
	this.m_mVertices=null;
	this.m_mNumIndices=0;
	this.m_mNumVertices=0;
	this.m_mVertexBuffer=0;
	this.m_mIndexBuffer=0;
	this.m_mStatus=0;
}
c_Surface.m_new=function(){
	return this;
}
c_Surface.prototype.p_Material=function(){
	return this.m_mMaterial;
}
c_Surface.m_Create=function(t_mat){
	var t_surf=c_Surface.m_new.call(new c_Surface);
	t_surf.m_mMaterial=c_Material.m_Create(null,null);
	if((t_mat)!=null){
		t_surf.m_mMaterial.p_Set6(t_mat);
		t_surf.m_mMaterial.p_Delegate(t_mat.p_Delegate2());
	}
	t_surf.m_mIndices=c_DataBuffer.m_new.call(new c_DataBuffer,256,true);
	t_surf.m_mVertices=c_DataBuffer.m_new.call(new c_DataBuffer,12800,true);
	t_surf.m_mNumIndices=0;
	t_surf.m_mNumVertices=0;
	t_surf.m_mVertexBuffer=c_Renderer.m_CreateVertexBuffer(0);
	t_surf.m_mIndexBuffer=c_Renderer.m_CreateIndexBuffer(0);
	t_surf.m_mStatus=0;
	return t_surf;
}
c_Surface.prototype.p_Rebuild=function(){
	if((this.m_mStatus&8)!=0){
		c_Renderer.m_ResizeIndexBuffer(this.m_mIndexBuffer,this.m_mNumIndices*2);
	}
	if((this.m_mStatus&4)!=0){
		c_Renderer.m_SetIndexBufferData(this.m_mIndexBuffer,0,this.m_mNumIndices*2,this.m_mIndices);
	}
	if((this.m_mStatus&2)!=0){
		c_Renderer.m_ResizeVertexBuffer(this.m_mVertexBuffer,this.m_mNumVertices*100);
	}
	if((this.m_mStatus&1)!=0){
		c_Renderer.m_SetVertexBufferData(this.m_mVertexBuffer,0,this.m_mNumVertices*100,this.m_mVertices);
	}
	this.m_mStatus=0;
}
c_Surface.prototype.p_Set5=function(t_other){
	if(this==t_other){
		return;
	}
	this.m_mStatus=5;
	if(this.m_mNumIndices!=t_other.m_mNumIndices){
		this.m_mStatus|=8;
	}
	if(this.m_mNumVertices!=t_other.m_mNumVertices){
		this.m_mStatus|=2;
	}
	this.m_mMaterial.p_Set6(t_other.m_mMaterial);
	if(this.m_mIndices.Length()!=t_other.m_mIndices.Length()){
		this.m_mIndices.Discard();
		this.m_mIndices=c_DataBuffer.m_new.call(new c_DataBuffer,t_other.m_mIndices.Length(),true);
	}
	t_other.m_mIndices.p_CopyBytes(0,this.m_mIndices,0,this.m_mIndices.Length());
	if(this.m_mVertices.Length()!=t_other.m_mVertices.Length()){
		this.m_mVertices.Discard();
		this.m_mVertices=c_DataBuffer.m_new.call(new c_DataBuffer,t_other.m_mVertices.Length(),true);
	}
	t_other.m_mVertices.p_CopyBytes(0,this.m_mVertices,0,this.m_mVertices.Length());
	this.m_mNumIndices=t_other.m_mNumIndices;
	this.m_mNumVertices=t_other.m_mNumVertices;
	this.p_Rebuild();
}
c_Surface.m_Create2=function(t_other){
	var t_surf=c_Surface.m_Create(t_other.m_mMaterial);
	t_surf.p_Set5(t_other);
	return t_surf;
}
c_Surface.prototype.p_NumVertices=function(){
	return this.m_mNumVertices;
}
c_Surface.prototype.p_AddVertex=function(t_x,t_y,t_z,t_nx,t_ny,t_nz,t_color,t_u0,t_v0){
	if(this.m_mVertices.Length()<(this.p_NumVertices()+1)*100){
		var t_buf=c_DataBuffer.m_new.call(new c_DataBuffer,this.m_mVertices.Length()+12800,false);
		this.m_mVertices.p_CopyBytes(0,t_buf,0,this.m_mVertices.Length());
		this.m_mVertices.Discard();
		this.m_mVertices=t_buf;
	}
	this.m_mVertices.PokeFloat(this.m_mNumVertices*100,t_x);
	this.m_mVertices.PokeFloat(this.m_mNumVertices*100+4,t_y);
	this.m_mVertices.PokeFloat(this.m_mNumVertices*100+8,t_z);
	this.m_mVertices.PokeFloat(this.m_mNumVertices*100+12,t_nx);
	this.m_mVertices.PokeFloat(this.m_mNumVertices*100+16,t_ny);
	this.m_mVertices.PokeFloat(this.m_mNumVertices*100+20,t_nz);
	this.m_mVertices.PokeFloat(this.m_mNumVertices*100+36,(c_Color.m_Red(t_color))/255.0);
	this.m_mVertices.PokeFloat(this.m_mNumVertices*100+40,(c_Color.m_Green(t_color))/255.0);
	this.m_mVertices.PokeFloat(this.m_mNumVertices*100+44,(c_Color.m_Blue(t_color))/255.0);
	this.m_mVertices.PokeFloat(this.m_mNumVertices*100+48,(c_Color.m_Alpha(t_color))/255.0);
	this.m_mVertices.PokeFloat(this.m_mNumVertices*100+52,t_u0);
	this.m_mVertices.PokeFloat(this.m_mNumVertices*100+56,t_v0);
	this.m_mVertices.PokeFloat(this.m_mNumVertices*100+60,t_u0);
	this.m_mVertices.PokeFloat(this.m_mNumVertices*100+64,t_v0);
	this.m_mNumVertices+=1;
	this.m_mStatus|=3;
	return this.p_NumVertices()-1;
}
c_Surface.prototype.p_SetVertexTangent=function(t_index,t_tx,t_ty,t_tz){
	this.m_mVertices.PokeFloat(t_index*100+24,t_tx);
	this.m_mVertices.PokeFloat(t_index*100+24+4,t_ty);
	this.m_mVertices.PokeFloat(t_index*100+24+8,t_tz);
	this.m_mStatus|=1;
}
c_Surface.prototype.p_NumTriangles=function(){
	return ((this.m_mNumIndices/3)|0);
}
c_Surface.prototype.p_AddTriangle=function(t_v0,t_v1,t_v2){
	if(this.m_mIndices.Length()<(this.m_mNumIndices+3)*2){
		var t_buf=c_DataBuffer.m_new.call(new c_DataBuffer,this.m_mIndices.Length()+256,false);
		this.m_mIndices.p_CopyBytes(0,t_buf,0,this.m_mIndices.Length());
		this.m_mIndices.Discard();
		this.m_mIndices=t_buf;
	}
	this.m_mIndices.PokeShort(this.m_mNumIndices*2,t_v0);
	this.m_mIndices.PokeShort(this.m_mNumIndices*2+2,t_v1);
	this.m_mIndices.PokeShort(this.m_mNumIndices*2+4,t_v2);
	this.m_mNumIndices+=3;
	this.m_mStatus|=12;
	return this.p_NumTriangles()-1;
}
c_Surface.prototype.p_VertexX=function(t_index){
	return this.m_mVertices.PeekFloat(t_index*100+0);
}
c_Surface.prototype.p_VertexY=function(t_index){
	return this.m_mVertices.PeekFloat(t_index*100+0+4);
}
c_Surface.prototype.p_VertexZ=function(t_index){
	return this.m_mVertices.PeekFloat(t_index*100+0+8);
}
c_Surface.prototype.p_SetVertexTexCoords=function(t_index,t_u,t_v,t_set){
	if(t_set==0){
		this.m_mVertices.PokeFloat(t_index*100+52,t_u);
		this.m_mVertices.PokeFloat(t_index*100+52+4,t_v);
	}else{
		this.m_mVertices.PokeFloat(t_index*100+60,t_u);
		this.m_mVertices.PokeFloat(t_index*100+60+4,t_v);
	}
	this.m_mStatus|=1;
}
c_Surface.prototype.p_SetVertexBone=function(t_vertex,t_index,t_bone,t_weight){
	this.m_mVertices.PokeFloat(t_vertex*100+68+t_index*4,(t_bone));
	this.m_mVertices.PokeFloat(t_vertex*100+84+t_index*4,t_weight);
	this.m_mStatus|=1;
}
c_Surface.prototype.p_Draw3=function(){
	c_Renderer.m_DrawBuffers(this.m_mVertexBuffer,this.m_mIndexBuffer,this.m_mNumIndices,0,12,24,36,52,60,68,84,100);
}
function c_Material(){
	Object.call(this);
	this.m_mDelegate=null;
	this.m_mColor=0;
	this.m_mBaseTex=null;
	this.m_mShininess=.0;
	this.m_mRefractCoef=.0;
	this.m_mBlendMode=0;
	this.m_mCulling=false;
	this.m_mDepthWrite=false;
	this.m_mNormalTex=null;
	this.m_mLightTex=null;
	this.m_mReflectTex=null;
	this.m_mRefractTex=null;
}
c_Material.m_new=function(){
	return this;
}
c_Material.m_Create=function(t_baseTex,t_delegate){
	var t_mat=c_Material.m_new.call(new c_Material);
	t_mat.m_mDelegate=t_delegate;
	t_mat.m_mColor=-1;
	t_mat.m_mBaseTex=t_baseTex;
	t_mat.m_mShininess=0.0;
	t_mat.m_mRefractCoef=1.0;
	t_mat.m_mBlendMode=0;
	t_mat.m_mCulling=true;
	t_mat.m_mDepthWrite=true;
	return t_mat;
}
c_Material.prototype.p_IsEqual=function(t_other){
	if(this==t_other){
		return true;
	}
	if(this.m_mColor==t_other.m_mColor && this.m_mBaseTex==t_other.m_mBaseTex && this.m_mNormalTex==t_other.m_mNormalTex && this.m_mLightTex==t_other.m_mLightTex && this.m_mReflectTex==t_other.m_mReflectTex && this.m_mRefractTex==t_other.m_mRefractTex && this.m_mShininess==t_other.m_mShininess && this.m_mRefractCoef==t_other.m_mRefractCoef && this.m_mBlendMode==t_other.m_mBlendMode && this.m_mCulling==t_other.m_mCulling && this.m_mDepthWrite==t_other.m_mDepthWrite){
		return true;
	}else{
		return false;
	}
}
c_Material.prototype.p_Set6=function(t_other){
	if(this.p_IsEqual(t_other)){
		return;
	}
	this.m_mColor=t_other.m_mColor;
	this.m_mBaseTex=t_other.m_mBaseTex;
	this.m_mNormalTex=t_other.m_mNormalTex;
	this.m_mLightTex=t_other.m_mLightTex;
	this.m_mReflectTex=t_other.m_mReflectTex;
	this.m_mRefractTex=t_other.m_mRefractTex;
	this.m_mShininess=t_other.m_mShininess;
	this.m_mRefractCoef=t_other.m_mRefractCoef;
	this.m_mBlendMode=t_other.m_mBlendMode;
	this.m_mCulling=t_other.m_mCulling;
	this.m_mDepthWrite=t_other.m_mDepthWrite;
	if((this.m_mDelegate)!=null){
		this.m_mDelegate.p_MaterialChanged(this);
	}
}
c_Material.m_Create2=function(t_other,t_delegate){
	var t_mat=c_Material.m_Create(null,t_delegate);
	t_mat.p_Set6(t_other);
	return t_mat;
}
c_Material.prototype.p_Delegate=function(t_delegate){
	this.m_mDelegate=t_delegate;
}
c_Material.prototype.p_Delegate2=function(){
	return this.m_mDelegate;
}
c_Material.prototype.p_DepthWrite=function(){
	return this.m_mDepthWrite;
}
c_Material.prototype.p_DepthWrite2=function(t_enable){
	if(this.m_mDepthWrite==t_enable){
		return;
	}
	this.m_mDepthWrite=t_enable;
	c_RenderList.m_Sort(this);
	if((this.m_mDelegate)!=null){
		this.m_mDelegate.p_MaterialChanged(this);
	}
}
c_Material.prototype.p_Color=function(t_color){
	if(this.m_mColor==t_color){
		return;
	}
	this.m_mColor=t_color;
	if((this.m_mDelegate)!=null){
		this.m_mDelegate.p_MaterialChanged(this);
	}
}
c_Material.prototype.p_Color2=function(){
	return this.m_mColor;
}
c_Material.prototype.p_BlendMode=function(t_mode){
	if(this.m_mBlendMode==t_mode){
		return;
	}
	this.m_mBlendMode=t_mode;
	if((this.m_mDelegate)!=null){
		this.m_mDelegate.p_MaterialChanged(this);
	}
}
c_Material.prototype.p_BlendMode2=function(){
	return this.m_mBlendMode;
}
c_Material.prototype.p_Culling=function(t_enable){
	if(this.m_mCulling==t_enable){
		return;
	}
	this.m_mCulling=t_enable;
	if((this.m_mDelegate)!=null){
		this.m_mDelegate.p_MaterialChanged(this);
	}
}
c_Material.prototype.p_Culling2=function(){
	return this.m_mCulling;
}
c_Material.prototype.p_Shininess=function(t_shininess){
	t_shininess=bb_math_Clamp2(t_shininess,0.0,1.0);
	if(this.m_mShininess==t_shininess){
		return;
	}
	this.m_mShininess=t_shininess;
	if((this.m_mDelegate)!=null){
		this.m_mDelegate.p_MaterialChanged(this);
	}
}
c_Material.prototype.p_Shininess2=function(){
	return this.m_mShininess;
}
c_Material.prototype.p_RefractionCoef=function(t_coef){
	if(this.m_mRefractCoef==t_coef){
		return;
	}
	this.m_mRefractCoef=t_coef;
	if((this.m_mDelegate)!=null){
		this.m_mDelegate.p_MaterialChanged(this);
	}
}
c_Material.prototype.p_RefractionCoef2=function(){
	return this.m_mRefractCoef;
}
c_Material.prototype.p_BaseTexture=function(t_tex){
	if(this.m_mBaseTex==t_tex){
		return;
	}
	this.m_mBaseTex=t_tex;
	if((this.m_mDelegate)!=null){
		this.m_mDelegate.p_MaterialChanged(this);
	}
}
c_Material.prototype.p_BaseTexture2=function(){
	return this.m_mBaseTex;
}
c_Material.prototype.p_NormalTexture=function(t_tex){
	if(this.m_mNormalTex==t_tex){
		return;
	}
	this.m_mNormalTex=t_tex;
	if((this.m_mDelegate)!=null){
		this.m_mDelegate.p_MaterialChanged(this);
	}
}
c_Material.prototype.p_NormalTexture2=function(){
	return this.m_mNormalTex;
}
c_Material.prototype.p_LightTexture=function(t_tex){
	if(this.m_mLightTex==t_tex){
		return;
	}
	this.m_mLightTex=t_tex;
	if((this.m_mDelegate)!=null){
		this.m_mDelegate.p_MaterialChanged(this);
	}
}
c_Material.prototype.p_LightTexture2=function(){
	return this.m_mLightTex;
}
c_Material.prototype.p_ReflectionTexture=function(t_tex){
	if(this.m_mReflectTex==t_tex){
		return;
	}
	this.m_mReflectTex=t_tex;
	if((this.m_mDelegate)!=null){
		this.m_mDelegate.p_MaterialChanged(this);
	}
}
c_Material.prototype.p_ReflectionTexture2=function(){
	return this.m_mReflectTex;
}
c_Material.prototype.p_RefractionTexture=function(t_tex){
	if(this.m_mRefractTex==t_tex){
		return;
	}
	this.m_mRefractTex=t_tex;
	if((this.m_mDelegate)!=null){
		this.m_mDelegate.p_MaterialChanged(this);
	}
}
c_Material.prototype.p_RefractionTexture2=function(){
	return this.m_mRefractTex;
}
c_Material.prototype.p_Prepare=function(){
	var t_baseHandle=0;
	var t_normalHandle=0;
	var t_lightHandle=0;
	var t_reflectHandle=0;
	var t_refractHandle=0;
	c_Renderer.m_SetColor2(this.m_mColor);
	c_Renderer.m_SetShininess(this.m_mShininess);
	c_Renderer.m_SetRefractCoef(this.m_mRefractCoef);
	c_Renderer.m_SetBlendMode(this.m_mBlendMode);
	c_Renderer.m_SetCulling(this.m_mCulling);
	c_Renderer.m_SetDepthWrite(this.m_mDepthWrite);
	if(this.m_mBaseTex!=null){
		t_baseHandle=this.m_mBaseTex.p_Handle();
	}
	if(this.m_mNormalTex!=null){
		t_normalHandle=this.m_mNormalTex.p_Handle();
	}
	if(this.m_mLightTex!=null){
		t_lightHandle=this.m_mLightTex.p_Handle();
	}
	if(this.m_mReflectTex!=null){
		t_reflectHandle=this.m_mReflectTex.p_Handle();
	}
	if(this.m_mRefractTex!=null){
		t_refractHandle=this.m_mRefractTex.p_Handle();
	}
	c_Renderer.m_SetTextures(t_baseHandle,t_normalHandle,t_lightHandle,t_reflectHandle,t_refractHandle,((this.m_mBaseTex)!=null) && this.m_mBaseTex.p_IsCubic());
}
function c_Color(){
	Object.call(this);
}
c_Color.m_Red=function(t_color){
	return t_color>>16&255;
}
c_Color.m_Green=function(t_color){
	return t_color>>8&255;
}
c_Color.m_Blue=function(t_color){
	return t_color&255;
}
c_Color.m_Alpha=function(t_color){
	return t_color>>24&255;
}
c_Color.m_RGB=function(t_r,t_g,t_b,t_a){
	return t_a<<24|t_r<<16|t_g<<8|t_b;
}
function c_Bone(){
	Object.call(this);
	this.m_mName="";
	this.m_mParentIndex=0;
	this.m_mInvPoseMatrix=null;
	this.m_mPositionKeys=[];
	this.m_mRotationKeys=[];
	this.m_mScaleKeys=[];
	this.m_mPositions=[];
	this.m_mRotations=[];
	this.m_mScales=[];
}
c_Bone.m_new=function(){
	return this;
}
c_Bone.m_Create=function(t_name,t_parentIndex){
	var t_bone=c_Bone.m_new.call(new c_Bone);
	t_bone.m_mName=t_name;
	t_bone.m_mParentIndex=t_parentIndex;
	t_bone.m_mInvPoseMatrix=c_Mat4.m_Create();
	t_bone.m_mPositionKeys=new_number_array(0);
	t_bone.m_mRotationKeys=new_number_array(0);
	t_bone.m_mScaleKeys=new_number_array(0);
	t_bone.m_mPositions=new_object_array(0);
	t_bone.m_mRotations=new_object_array(0);
	t_bone.m_mScales=new_object_array(0);
	return t_bone;
}
c_Bone.m_Create2=function(t_other){
	var t_bone=c_Bone.m_Create(t_other.m_mName,t_other.m_mParentIndex);
	t_bone.m_mInvPoseMatrix=c_Mat4.m_Create2(t_other.m_mInvPoseMatrix);
	t_bone.m_mPositionKeys=t_other.m_mPositionKeys.slice(0);
	t_bone.m_mRotationKeys=t_other.m_mRotationKeys.slice(0);
	t_bone.m_mScaleKeys=t_other.m_mScaleKeys.slice(0);
	t_bone.m_mPositions=new_object_array(t_other.m_mPositions.length);
	for(var t_i=0;t_i<t_other.m_mPositions.length;t_i=t_i+1){
		t_bone.m_mPositions[t_i]=c_Vec3.m_Create2(t_other.m_mPositions[t_i]);
	}
	t_bone.m_mRotations=new_object_array(t_other.m_mRotations.length);
	for(var t_i2=0;t_i2<t_other.m_mRotations.length;t_i2=t_i2+1){
		t_bone.m_mRotations[t_i2]=c_Quat.m_Create2(t_other.m_mRotations[t_i2]);
	}
	t_bone.m_mScales=new_object_array(t_other.m_mScales.length);
	for(var t_i3=0;t_i3<t_other.m_mScales.length;t_i3=t_i3+1){
		t_bone.m_mScales[t_i3]=c_Vec3.m_Create2(t_other.m_mScales[t_i3]);
	}
	return t_bone;
}
c_Bone.prototype.p_InversePoseMatrix=function(t_m){
	this.m_mInvPoseMatrix.p_Set9(t_m);
}
c_Bone.prototype.p_InversePoseMatrix2=function(){
	return this.m_mInvPoseMatrix;
}
c_Bone.prototype.p_AddPositionKey=function(t_keyframe,t_x,t_y,t_z){
	this.m_mPositionKeys=resize_number_array(this.m_mPositionKeys,this.m_mPositionKeys.length+1);
	this.m_mPositions=resize_object_array(this.m_mPositions,this.m_mPositions.length+1);
	this.m_mPositionKeys[this.m_mPositionKeys.length-1]=t_keyframe;
	this.m_mPositions[this.m_mPositions.length-1]=c_Vec3.m_Create(t_x,t_y,t_z);
}
c_Bone.prototype.p_AddRotationKey=function(t_keyframe,t_w,t_x,t_y,t_z){
	this.m_mRotationKeys=resize_number_array(this.m_mRotationKeys,this.m_mRotationKeys.length+1);
	this.m_mRotations=resize_object_array(this.m_mRotations,this.m_mRotations.length+1);
	this.m_mRotationKeys[this.m_mRotationKeys.length-1]=t_keyframe;
	this.m_mRotations[this.m_mRotations.length-1]=c_Quat.m_Create(t_w,t_x,t_y,t_z);
}
c_Bone.prototype.p_AddScaleKey=function(t_keyframe,t_x,t_y,t_z){
	this.m_mScaleKeys=resize_number_array(this.m_mScaleKeys,this.m_mScaleKeys.length+1);
	this.m_mScales=resize_object_array(this.m_mScales,this.m_mScales.length+1);
	this.m_mScaleKeys[this.m_mScaleKeys.length-1]=t_keyframe;
	this.m_mScales[this.m_mScales.length-1]=c_Vec3.m_Create(t_x,t_y,t_z);
}
c_Bone.prototype.p_ParentIndex=function(){
	return this.m_mParentIndex;
}
c_Bone.m_mTempVec=null;
c_Bone.prototype.p_CalcPosition=function(t_frame,t_firstSeqFrame,t_lastSeqFrame){
	var t_firstFrameIndex=-1;
	for(var t_i=0;t_i<this.m_mPositionKeys.length;t_i=t_i+1){
		if(this.m_mPositionKeys[t_i]<t_firstSeqFrame){
			continue;
		}else{
			if(this.m_mPositionKeys[t_i]==t_firstSeqFrame){
				t_firstFrameIndex=t_i;
			}
		}
		if((this.m_mPositionKeys[t_i])==t_frame){
			c_Bone.m_mTempVec.p_Set8(this.m_mPositions[t_i]);
			return;
		}else{
			if((this.m_mPositionKeys[t_i])>t_frame){
				c_Bone.m_mTempVec.p_Set8(this.m_mPositions[t_i-1]);
				c_Bone.m_mTempVec.p_Mix(this.m_mPositions[t_i],(t_frame-(this.m_mPositionKeys[t_i-1]))/(this.m_mPositionKeys[t_i]-this.m_mPositionKeys[t_i-1]));
				return;
			}else{
				if(this.m_mPositionKeys[t_i]>t_lastSeqFrame){
					c_Bone.m_mTempVec.p_Set8(this.m_mPositions[t_i-1]);
					c_Bone.m_mTempVec.p_Mix(this.m_mPositions[t_firstFrameIndex],t_frame-((t_frame)|0));
					return;
				}
			}
		}
	}
	c_Bone.m_mTempVec.p_Set8(this.m_mPositions[this.m_mPositions.length-1]);
	c_Bone.m_mTempVec.p_Mix(this.m_mPositions[t_firstFrameIndex],t_frame-((t_frame)|0));
}
c_Bone.m_mTempQuat=null;
c_Bone.prototype.p_CalcRotation=function(t_frame,t_firstSeqFrame,t_lastSeqFrame){
	var t_firstFrameIndex=-1;
	for(var t_i=0;t_i<this.m_mRotationKeys.length;t_i=t_i+1){
		if(this.m_mRotationKeys[t_i]<t_firstSeqFrame){
			continue;
		}else{
			if(this.m_mRotationKeys[t_i]==t_firstSeqFrame){
				t_firstFrameIndex=t_i;
			}
		}
		if((this.m_mRotationKeys[t_i])==t_frame){
			c_Bone.m_mTempQuat.p_Set12(this.m_mRotations[t_i]);
			return;
		}else{
			if((this.m_mRotationKeys[t_i])>t_frame){
				c_Bone.m_mTempQuat.p_Set12(this.m_mRotations[t_i-1]);
				c_Bone.m_mTempQuat.p_Slerp(this.m_mRotations[t_i],(t_frame-(this.m_mRotationKeys[t_i-1]))/(this.m_mRotationKeys[t_i]-this.m_mRotationKeys[t_i-1]));
				return;
			}else{
				if(this.m_mRotationKeys[t_i]>t_lastSeqFrame){
					c_Bone.m_mTempQuat.p_Set12(this.m_mRotations[t_i-1]);
					c_Bone.m_mTempQuat.p_Slerp(this.m_mRotations[t_firstFrameIndex],t_frame-((t_frame)|0));
					return;
				}
			}
		}
	}
	c_Bone.m_mTempQuat.p_Set12(this.m_mRotations[this.m_mRotations.length-1]);
	c_Bone.m_mTempQuat.p_Slerp(this.m_mRotations[t_firstFrameIndex],t_frame-((t_frame)|0));
}
c_Bone.prototype.p_CalcScale=function(t_frame,t_firstSeqFrame,t_lastSeqFrame){
	var t_firstFrameIndex=-1;
	for(var t_i=0;t_i<this.m_mScaleKeys.length;t_i=t_i+1){
		if(this.m_mScaleKeys[t_i]<t_firstSeqFrame){
			continue;
		}else{
			if(this.m_mScaleKeys[t_i]==t_firstSeqFrame){
				t_firstFrameIndex=t_i;
			}
		}
		if((this.m_mScaleKeys[t_i])==t_frame){
			c_Bone.m_mTempVec.p_Set8(this.m_mScales[t_i]);
			return;
		}else{
			if((this.m_mScaleKeys[t_i])>t_frame){
				c_Bone.m_mTempVec.p_Set8(this.m_mScales[t_i-1]);
				c_Bone.m_mTempVec.p_Mix(this.m_mScales[t_i],(t_frame-(this.m_mScaleKeys[t_i-1]))/(this.m_mScaleKeys[t_i]-this.m_mScaleKeys[t_i-1]));
				return;
			}else{
				if(this.m_mScaleKeys[t_i]>t_lastSeqFrame){
					c_Bone.m_mTempVec.p_Set8(this.m_mScales[t_i-1]);
					c_Bone.m_mTempVec.p_Mix(this.m_mScales[t_firstFrameIndex],t_frame-((t_frame)|0));
					return;
				}
			}
		}
	}
	c_Bone.m_mTempVec.p_Set8(this.m_mScales[this.m_mScales.length-1]);
	c_Bone.m_mTempVec.p_Mix(this.m_mScales[t_firstFrameIndex],t_frame-((t_frame)|0));
}
c_Bone.prototype.p_CalculateAnimMatrix=function(t_animMatrix,t_frame,t_firstFrame,t_lastFrame){
	var t_keyInRange=false;
	var t_=this.m_mPositionKeys;
	var t_2=0;
	while(t_2<t_.length){
		var t_i=t_[t_2];
		t_2=t_2+1;
		if(t_i>=t_firstFrame && t_i<=t_lastFrame){
			t_keyInRange=true;
			break;
		}
	}
	if(t_keyInRange){
		var t_px=.0;
		var t_py=.0;
		var t_pz=.0;
		var t_ra=.0;
		var t_rx=.0;
		var t_ry=.0;
		var t_rz=.0;
		var t_sx=.0;
		var t_sy=.0;
		var t_sz=.0;
		this.p_CalcPosition(t_frame,t_firstFrame,t_lastFrame);
		t_px=c_Bone.m_mTempVec.m_X;
		t_py=c_Bone.m_mTempVec.m_Y;
		t_pz=c_Bone.m_mTempVec.m_Z;
		this.p_CalcRotation(t_frame,t_firstFrame,t_lastFrame);
		c_Bone.m_mTempQuat.p_CalcAxis();
		t_ra=c_Bone.m_mTempQuat.p_Angle();
		t_rx=c_Quat.m_ResultVector().m_X;
		t_ry=c_Quat.m_ResultVector().m_Y;
		t_rz=c_Quat.m_ResultVector().m_Z;
		this.p_CalcScale(t_frame,t_firstFrame,t_lastFrame);
		t_sx=c_Bone.m_mTempVec.m_X;
		t_sy=c_Bone.m_mTempVec.m_Y;
		t_sz=c_Bone.m_mTempVec.m_Z;
		t_animMatrix.p_SetIdentity();
		t_animMatrix.p_Translate(t_px,t_py,t_pz);
		t_animMatrix.p_Rotate(t_ra,t_rx,t_ry,t_rz);
	}else{
		t_animMatrix.p_SetIdentity();
	}
}
function c_Vec3(){
	Object.call(this);
	this.m_X=.0;
	this.m_Y=.0;
	this.m_Z=.0;
}
c_Vec3.m_new=function(){
	return this;
}
c_Vec3.prototype.p_Set7=function(t_x,t_y,t_z){
	this.m_X=t_x;
	this.m_Y=t_y;
	this.m_Z=t_z;
}
c_Vec3.prototype.p_Set8=function(t_other){
	this.m_X=t_other.m_X;
	this.m_Y=t_other.m_Y;
	this.m_Z=t_other.m_Z;
}
c_Vec3.m_Create=function(t_x,t_y,t_z){
	var t_v=c_Vec3.m_new.call(new c_Vec3);
	t_v.p_Set7(t_x,t_y,t_z);
	return t_v;
}
c_Vec3.m_Create2=function(t_other){
	var t_v=c_Vec3.m_new.call(new c_Vec3);
	t_v.p_Set8(t_other);
	return t_v;
}
c_Vec3.prototype.p_Div=function(t_other){
	this.m_X/=t_other.m_X;
	this.m_Y/=t_other.m_Y;
	this.m_Z/=t_other.m_Z;
}
c_Vec3.prototype.p_Mul=function(t_other){
	this.m_X*=t_other.m_X;
	this.m_Y*=t_other.m_Y;
	this.m_Z*=t_other.m_Z;
}
c_Vec3.prototype.p_Mul2=function(t_scalar){
	this.m_X*=t_scalar;
	this.m_Y*=t_scalar;
	this.m_Z*=t_scalar;
}
c_Vec3.prototype.p_Div2=function(t_scalar){
	this.p_Mul2(1.0/t_scalar);
}
c_Vec3.prototype.p_Sub=function(t_other){
	this.m_X-=t_other.m_X;
	this.m_Y-=t_other.m_Y;
	this.m_Z-=t_other.m_Z;
}
c_Vec3.prototype.p_Sub2=function(t_x,t_y,t_z){
	this.m_X-=t_x;
	this.m_Y-=t_y;
	this.m_Z-=t_z;
}
c_Vec3.prototype.p_Sub3=function(t_scalar){
	this.m_X-=t_scalar;
	this.m_Y-=t_scalar;
	this.m_Z-=t_scalar;
}
c_Vec3.prototype.p_Length=function(){
	return Math.sqrt(this.m_X*this.m_X+this.m_Y*this.m_Y+this.m_Z*this.m_Z);
}
c_Vec3.prototype.p_Normalize=function(){
	this.p_Div2(this.p_Length());
}
c_Vec3.prototype.p_Cross=function(t_otherx,t_othery,t_otherz){
	var t_newx=this.m_Y*t_otherz-this.m_Z*t_othery;
	var t_newy=this.m_Z*t_otherx-this.m_X*t_otherz;
	var t_newz=this.m_X*t_othery-this.m_Y*t_otherx;
	this.p_Set7(t_newx,t_newy,t_newz);
}
c_Vec3.prototype.p_Cross2=function(t_other){
	this.p_Cross(t_other.m_X,t_other.m_Y,t_other.m_Z);
}
c_Vec3.prototype.p_Mix=function(t_other,t_t){
	this.m_X+=(t_other.m_X-this.m_X)*t_t;
	this.m_Y+=(t_other.m_Y-this.m_Y)*t_t;
	this.m_Z+=(t_other.m_Z-this.m_Z)*t_t;
}
function c_Mat4(){
	Object.call(this);
	this.m_M=new_number_array(16);
}
c_Mat4.m_new=function(){
	return this;
}
c_Mat4.prototype.p_SetIdentity=function(){
	for(var t_i=0;t_i<16;t_i=t_i+1){
		this.m_M[t_i]=0.0;
	}
	this.m_M[0]=1.0;
	this.m_M[5]=1.0;
	this.m_M[10]=1.0;
	this.m_M[15]=1.0;
}
c_Mat4.m_Create=function(){
	var t_m=c_Mat4.m_new.call(new c_Mat4);
	t_m.p_SetIdentity();
	return t_m;
}
c_Mat4.m_Create2=function(t_other){
	var t_m=c_Mat4.m_new.call(new c_Mat4);
	for(var t_i=0;t_i<16;t_i=t_i+1){
		t_m.m_M[t_i]=t_other.m_M[t_i];
	}
	return t_m;
}
c_Mat4.prototype.p_Set9=function(t_other){
	for(var t_i=0;t_i<16;t_i=t_i+1){
		this.m_M[t_i]=t_other.m_M[t_i];
	}
}
c_Mat4.prototype.p_Set10=function(t_m){
	for(var t_i=0;t_i<16;t_i=t_i+1){
		this.m_M[t_i]=t_m[t_i];
	}
}
c_Mat4.m_Create3=function(t_values){
	var t_m=c_Mat4.m_new.call(new c_Mat4);
	t_m.p_Set10(t_values);
	return t_m;
}
c_Mat4.m_q1=null;
c_Mat4.m_t1=null;
c_Mat4.prototype.p_SetTranslation=function(t_x,t_y,t_z){
	this.m_M[12]=t_x;
	this.m_M[13]=t_y;
	this.m_M[14]=t_z;
}
c_Mat4.prototype.p_Mul3=function(t_arr){
	for(var t_i=0;t_i<4;t_i=t_i+1){
		var t_a0=this.m_M[t_i];
		var t_a1=this.m_M[t_i+4];
		var t_a2=this.m_M[t_i+8];
		var t_a3=this.m_M[t_i+12];
		this.m_M[t_i]=t_a0*t_arr[0]+t_a1*t_arr[1]+t_a2*t_arr[2]+t_a3*t_arr[3];
		this.m_M[t_i+4]=t_a0*t_arr[4]+t_a1*t_arr[5]+t_a2*t_arr[6]+t_a3*t_arr[7];
		this.m_M[t_i+8]=t_a0*t_arr[8]+t_a1*t_arr[9]+t_a2*t_arr[10]+t_a3*t_arr[11];
		this.m_M[t_i+12]=t_a0*t_arr[12]+t_a1*t_arr[13]+t_a2*t_arr[14]+t_a3*t_arr[15];
	}
}
c_Mat4.m_t2=null;
c_Mat4.m_tv1=null;
c_Mat4.prototype.p_Mul4=function(t_x,t_y,t_z,t_w){
	c_Mat4.m_t1.p_SetIdentity();
	c_Mat4.m_t1.p_SetTranslation(t_x,t_y,t_z);
	c_Mat4.m_t1.m_M[15]=t_w;
	c_Mat4.m_t2.p_Set9(this);
	c_Mat4.m_t2.p_Mul6(c_Mat4.m_t1);
	c_Mat4.m_tv1.p_Set7(c_Mat4.m_t2.m_M[12],c_Mat4.m_t2.m_M[13],c_Mat4.m_t2.m_M[14]);
	return c_Mat4.m_t2.m_M[15];
}
c_Mat4.prototype.p_Mul5=function(t_vec,t_w){
	return this.p_Mul4(t_vec.m_X,t_vec.m_Y,t_vec.m_Z,t_w);
}
c_Mat4.prototype.p_Mul6=function(t_other){
	this.p_Mul3(t_other.m_M);
}
c_Mat4.prototype.p_Translate=function(t_x,t_y,t_z){
	c_Mat4.m_t1.p_SetIdentity();
	c_Mat4.m_t1.p_SetTranslation(t_x,t_y,t_z);
	this.p_Mul6(c_Mat4.m_t1);
}
c_Mat4.prototype.p_SetRotation=function(t_angle,t_x,t_y,t_z){
	var t_c=Math.cos((t_angle)*D2R);
	var t_s=Math.sin((t_angle)*D2R);
	var t_xx=t_x*t_x;
	var t_xy=t_x*t_y;
	var t_xz=t_x*t_z;
	var t_yy=t_y*t_y;
	var t_yz=t_y*t_z;
	var t_zz=t_z*t_z;
	this.m_M[0]=t_xx*(1.0-t_c)+t_c;
	this.m_M[1]=t_xy*(1.0-t_c)+t_z*t_s;
	this.m_M[2]=t_xz*(1.0-t_c)-t_y*t_s;
	this.m_M[4]=t_xy*(1.0-t_c)-t_z*t_s;
	this.m_M[5]=t_yy*(1.0-t_c)+t_c;
	this.m_M[6]=t_yz*(1.0-t_c)+t_x*t_s;
	this.m_M[8]=t_xz*(1.0-t_c)+t_y*t_s;
	this.m_M[9]=t_yz*(1.0-t_c)-t_x*t_s;
	this.m_M[10]=t_zz*(1.0-t_c)+t_c;
}
c_Mat4.prototype.p_Rotate=function(t_angle,t_x,t_y,t_z){
	c_Mat4.m_t1.p_SetIdentity();
	c_Mat4.m_t1.p_SetRotation(t_angle,t_x,t_y,t_z);
	this.p_Mul6(c_Mat4.m_t1);
}
c_Mat4.prototype.p_SetScale=function(t_x,t_y,t_z){
	this.m_M[0]=t_x;
	this.m_M[5]=t_y;
	this.m_M[10]=t_z;
}
c_Mat4.prototype.p_Scale=function(t_x,t_y,t_z){
	c_Mat4.m_t1.p_SetIdentity();
	c_Mat4.m_t1.p_SetScale(t_x,t_y,t_z);
	this.p_Mul6(c_Mat4.m_t1);
}
c_Mat4.prototype.p_SetTransform=function(t_x,t_y,t_z,t_rw,t_rx,t_ry,t_rz,t_sx,t_sy,t_sz){
	c_Mat4.m_q1.p_Set11(t_rw,t_rx,t_ry,t_rz);
	c_Mat4.m_q1.p_CalcAxis();
	this.p_SetIdentity();
	this.p_Translate(t_x,t_y,t_z);
	this.p_Rotate(c_Mat4.m_q1.p_Angle(),c_Quat.m_ResultVector().m_X,c_Quat.m_ResultVector().m_Y,c_Quat.m_ResultVector().m_Z);
	this.p_Scale(t_sx,t_sy,t_sz);
}
c_Mat4.prototype.p_SetTransform2=function(t_x,t_y,t_z,t_rx,t_ry,t_rz,t_sx,t_sy,t_sz){
	c_Mat4.m_q1.p_SetEuler(t_rx,t_ry,t_rz);
	c_Mat4.m_q1.p_CalcAxis();
	this.p_SetIdentity();
	this.p_Translate(t_x,t_y,t_z);
	this.p_Rotate(c_Mat4.m_q1.p_Angle(),c_Quat.m_ResultVector().m_X,c_Quat.m_ResultVector().m_Y,c_Quat.m_ResultVector().m_Z);
	this.p_Scale(t_sx,t_sy,t_sz);
}
c_Mat4.prototype.p_SetTransform3=function(t_position,t_rotation,t_scale){
	this.p_SetTransform2(t_position.m_X,t_position.m_Y,t_position.m_Z,t_rotation.m_X,t_rotation.m_Y,t_rotation.m_Z,t_scale.m_X,t_scale.m_Y,t_scale.m_Z);
}
c_Mat4.prototype.p_SetTransform4=function(t_position,t_rotation,t_scale){
	this.p_SetTransform(t_position.m_X,t_position.m_Y,t_position.m_Z,t_rotation.m_W,t_rotation.m_X,t_rotation.m_Y,t_rotation.m_Z,t_scale.m_X,t_scale.m_Y,t_scale.m_Z);
}
c_Mat4.prototype.p_SetOrthoLH=function(t_left,t_right,t_bottom,t_top,t_near,t_far){
	var t_a=2.0/(t_right-t_left);
	var t_b=2.0/(t_top-t_bottom);
	var t_c=2.0/(t_far-t_near);
	var t_tx=(t_left+t_right)/(t_left-t_right);
	var t_ty=(t_bottom+t_top)/(t_bottom-t_top);
	var t_tz=(t_near+t_far)/(t_near-t_far);
	var t_m=[t_a,0.0,0.0,0.0,0.0,t_b,0.0,0.0,0.0,0.0,t_c,0.0,t_tx,t_ty,t_tz,1.0];
	this.p_Set10(t_m);
}
c_Mat4.prototype.p_SetOrthoLH2=function(t_height,t_aspect,t_near,t_far){
	var t_halfHeight=t_height*0.5;
	var t_halfWidth=t_halfHeight*t_aspect;
	this.p_SetOrthoLH(-t_halfWidth,t_halfWidth,-t_halfHeight,t_halfHeight,t_near,t_far);
}
c_Mat4.m_tv3=null;
c_Mat4.m_tv2=null;
c_Mat4.prototype.p_LookAtLH=function(t_eyex,t_eyey,t_eyez,t_centerx,t_centery,t_centerz,t_upx,t_upy,t_upz){
	c_Mat4.m_tv3.p_Set7(t_centerx,t_centery,t_centerz);
	c_Mat4.m_tv3.p_Sub2(t_eyex,t_eyey,t_eyez);
	c_Mat4.m_tv3.p_Normalize();
	c_Mat4.m_tv1.p_Set7(t_upx,t_upy,t_upz);
	c_Mat4.m_tv1.p_Cross2(c_Mat4.m_tv3);
	c_Mat4.m_tv1.p_Normalize();
	c_Mat4.m_tv2.p_Set8(c_Mat4.m_tv3);
	c_Mat4.m_tv2.p_Cross2(c_Mat4.m_tv1);
	this.m_M[0]=c_Mat4.m_tv1.m_X;
	this.m_M[1]=c_Mat4.m_tv2.m_X;
	this.m_M[2]=c_Mat4.m_tv3.m_X;
	this.m_M[3]=0.0;
	this.m_M[4]=c_Mat4.m_tv1.m_Y;
	this.m_M[5]=c_Mat4.m_tv2.m_Y;
	this.m_M[6]=c_Mat4.m_tv3.m_Y;
	this.m_M[7]=0.0;
	this.m_M[8]=c_Mat4.m_tv1.m_Z;
	this.m_M[9]=c_Mat4.m_tv2.m_Z;
	this.m_M[10]=c_Mat4.m_tv3.m_Z;
	this.m_M[11]=0.0;
	this.m_M[12]=0.0;
	this.m_M[13]=0.0;
	this.m_M[14]=0.0;
	this.m_M[15]=1.0;
	this.p_Translate(-t_eyex,-t_eyey,-t_eyez);
}
c_Mat4.prototype.p_Invert=function(){
	c_Mat4.m_t1.p_Set9(this);
	this.m_M[0]=c_Mat4.m_t1.m_M[5]*c_Mat4.m_t1.m_M[10]*c_Mat4.m_t1.m_M[15]-c_Mat4.m_t1.m_M[5]*c_Mat4.m_t1.m_M[11]*c_Mat4.m_t1.m_M[14]-c_Mat4.m_t1.m_M[9]*c_Mat4.m_t1.m_M[6]*c_Mat4.m_t1.m_M[15]+c_Mat4.m_t1.m_M[9]*c_Mat4.m_t1.m_M[7]*c_Mat4.m_t1.m_M[14]+c_Mat4.m_t1.m_M[13]*c_Mat4.m_t1.m_M[6]*c_Mat4.m_t1.m_M[11]-c_Mat4.m_t1.m_M[13]*c_Mat4.m_t1.m_M[7]*c_Mat4.m_t1.m_M[10];
	this.m_M[4]=-c_Mat4.m_t1.m_M[4]*c_Mat4.m_t1.m_M[10]*c_Mat4.m_t1.m_M[15]+c_Mat4.m_t1.m_M[4]*c_Mat4.m_t1.m_M[11]*c_Mat4.m_t1.m_M[14]+c_Mat4.m_t1.m_M[8]*c_Mat4.m_t1.m_M[6]*c_Mat4.m_t1.m_M[15]-c_Mat4.m_t1.m_M[8]*c_Mat4.m_t1.m_M[7]*c_Mat4.m_t1.m_M[14]-c_Mat4.m_t1.m_M[12]*c_Mat4.m_t1.m_M[6]*c_Mat4.m_t1.m_M[11]+c_Mat4.m_t1.m_M[12]*c_Mat4.m_t1.m_M[7]*c_Mat4.m_t1.m_M[10];
	this.m_M[8]=c_Mat4.m_t1.m_M[4]*c_Mat4.m_t1.m_M[9]*c_Mat4.m_t1.m_M[15]-c_Mat4.m_t1.m_M[4]*c_Mat4.m_t1.m_M[11]*c_Mat4.m_t1.m_M[13]-c_Mat4.m_t1.m_M[8]*c_Mat4.m_t1.m_M[5]*c_Mat4.m_t1.m_M[15]+c_Mat4.m_t1.m_M[8]*c_Mat4.m_t1.m_M[7]*c_Mat4.m_t1.m_M[13]+c_Mat4.m_t1.m_M[12]*c_Mat4.m_t1.m_M[5]*c_Mat4.m_t1.m_M[11]-c_Mat4.m_t1.m_M[12]*c_Mat4.m_t1.m_M[7]*c_Mat4.m_t1.m_M[9];
	this.m_M[12]=-c_Mat4.m_t1.m_M[4]*c_Mat4.m_t1.m_M[9]*c_Mat4.m_t1.m_M[14]+c_Mat4.m_t1.m_M[4]*c_Mat4.m_t1.m_M[10]*c_Mat4.m_t1.m_M[13]+c_Mat4.m_t1.m_M[8]*c_Mat4.m_t1.m_M[5]*c_Mat4.m_t1.m_M[14]-c_Mat4.m_t1.m_M[8]*c_Mat4.m_t1.m_M[6]*c_Mat4.m_t1.m_M[13]-c_Mat4.m_t1.m_M[12]*c_Mat4.m_t1.m_M[5]*c_Mat4.m_t1.m_M[10]+c_Mat4.m_t1.m_M[12]*c_Mat4.m_t1.m_M[6]*c_Mat4.m_t1.m_M[9];
	this.m_M[1]=-c_Mat4.m_t1.m_M[1]*c_Mat4.m_t1.m_M[10]*c_Mat4.m_t1.m_M[15]+c_Mat4.m_t1.m_M[1]*c_Mat4.m_t1.m_M[11]*c_Mat4.m_t1.m_M[14]+c_Mat4.m_t1.m_M[9]*c_Mat4.m_t1.m_M[2]*c_Mat4.m_t1.m_M[15]-c_Mat4.m_t1.m_M[9]*c_Mat4.m_t1.m_M[3]*c_Mat4.m_t1.m_M[14]-c_Mat4.m_t1.m_M[13]*c_Mat4.m_t1.m_M[2]*c_Mat4.m_t1.m_M[11]+c_Mat4.m_t1.m_M[13]*c_Mat4.m_t1.m_M[3]*c_Mat4.m_t1.m_M[10];
	this.m_M[5]=c_Mat4.m_t1.m_M[0]*c_Mat4.m_t1.m_M[10]*c_Mat4.m_t1.m_M[15]-c_Mat4.m_t1.m_M[0]*c_Mat4.m_t1.m_M[11]*c_Mat4.m_t1.m_M[14]-c_Mat4.m_t1.m_M[8]*c_Mat4.m_t1.m_M[2]*c_Mat4.m_t1.m_M[15]+c_Mat4.m_t1.m_M[8]*c_Mat4.m_t1.m_M[3]*c_Mat4.m_t1.m_M[14]+c_Mat4.m_t1.m_M[12]*c_Mat4.m_t1.m_M[2]*c_Mat4.m_t1.m_M[11]-c_Mat4.m_t1.m_M[12]*c_Mat4.m_t1.m_M[3]*c_Mat4.m_t1.m_M[10];
	this.m_M[9]=-c_Mat4.m_t1.m_M[0]*c_Mat4.m_t1.m_M[9]*c_Mat4.m_t1.m_M[15]+c_Mat4.m_t1.m_M[0]*c_Mat4.m_t1.m_M[11]*c_Mat4.m_t1.m_M[13]+c_Mat4.m_t1.m_M[8]*c_Mat4.m_t1.m_M[1]*c_Mat4.m_t1.m_M[15]-c_Mat4.m_t1.m_M[8]*c_Mat4.m_t1.m_M[3]*c_Mat4.m_t1.m_M[13]-c_Mat4.m_t1.m_M[12]*c_Mat4.m_t1.m_M[1]*c_Mat4.m_t1.m_M[11]+c_Mat4.m_t1.m_M[12]*c_Mat4.m_t1.m_M[3]*c_Mat4.m_t1.m_M[9];
	this.m_M[13]=c_Mat4.m_t1.m_M[0]*c_Mat4.m_t1.m_M[9]*c_Mat4.m_t1.m_M[14]-c_Mat4.m_t1.m_M[0]*c_Mat4.m_t1.m_M[10]*c_Mat4.m_t1.m_M[13]-c_Mat4.m_t1.m_M[8]*c_Mat4.m_t1.m_M[1]*c_Mat4.m_t1.m_M[14]+c_Mat4.m_t1.m_M[8]*c_Mat4.m_t1.m_M[2]*c_Mat4.m_t1.m_M[13]+c_Mat4.m_t1.m_M[12]*c_Mat4.m_t1.m_M[1]*c_Mat4.m_t1.m_M[10]-c_Mat4.m_t1.m_M[12]*c_Mat4.m_t1.m_M[2]*c_Mat4.m_t1.m_M[9];
	this.m_M[2]=c_Mat4.m_t1.m_M[1]*c_Mat4.m_t1.m_M[6]*c_Mat4.m_t1.m_M[15]-c_Mat4.m_t1.m_M[1]*c_Mat4.m_t1.m_M[7]*c_Mat4.m_t1.m_M[14]-c_Mat4.m_t1.m_M[5]*c_Mat4.m_t1.m_M[2]*c_Mat4.m_t1.m_M[15]+c_Mat4.m_t1.m_M[5]*c_Mat4.m_t1.m_M[3]*c_Mat4.m_t1.m_M[14]+c_Mat4.m_t1.m_M[13]*c_Mat4.m_t1.m_M[2]*c_Mat4.m_t1.m_M[7]-c_Mat4.m_t1.m_M[13]*c_Mat4.m_t1.m_M[3]*c_Mat4.m_t1.m_M[6];
	this.m_M[6]=-c_Mat4.m_t1.m_M[0]*c_Mat4.m_t1.m_M[6]*c_Mat4.m_t1.m_M[15]+c_Mat4.m_t1.m_M[0]*c_Mat4.m_t1.m_M[7]*c_Mat4.m_t1.m_M[14]+c_Mat4.m_t1.m_M[4]*c_Mat4.m_t1.m_M[2]*c_Mat4.m_t1.m_M[15]-c_Mat4.m_t1.m_M[4]*c_Mat4.m_t1.m_M[3]*c_Mat4.m_t1.m_M[14]-c_Mat4.m_t1.m_M[12]*c_Mat4.m_t1.m_M[2]*c_Mat4.m_t1.m_M[7]+c_Mat4.m_t1.m_M[12]*c_Mat4.m_t1.m_M[3]*c_Mat4.m_t1.m_M[6];
	this.m_M[10]=c_Mat4.m_t1.m_M[0]*c_Mat4.m_t1.m_M[5]*c_Mat4.m_t1.m_M[15]-c_Mat4.m_t1.m_M[0]*c_Mat4.m_t1.m_M[7]*c_Mat4.m_t1.m_M[13]-c_Mat4.m_t1.m_M[4]*c_Mat4.m_t1.m_M[1]*c_Mat4.m_t1.m_M[15]+c_Mat4.m_t1.m_M[4]*c_Mat4.m_t1.m_M[3]*c_Mat4.m_t1.m_M[13]+c_Mat4.m_t1.m_M[12]*c_Mat4.m_t1.m_M[1]*c_Mat4.m_t1.m_M[7]-c_Mat4.m_t1.m_M[12]*c_Mat4.m_t1.m_M[3]*c_Mat4.m_t1.m_M[5];
	this.m_M[14]=-c_Mat4.m_t1.m_M[0]*c_Mat4.m_t1.m_M[5]*c_Mat4.m_t1.m_M[14]+c_Mat4.m_t1.m_M[0]*c_Mat4.m_t1.m_M[6]*c_Mat4.m_t1.m_M[13]+c_Mat4.m_t1.m_M[4]*c_Mat4.m_t1.m_M[1]*c_Mat4.m_t1.m_M[14]-c_Mat4.m_t1.m_M[4]*c_Mat4.m_t1.m_M[2]*c_Mat4.m_t1.m_M[13]-c_Mat4.m_t1.m_M[12]*c_Mat4.m_t1.m_M[1]*c_Mat4.m_t1.m_M[6]+c_Mat4.m_t1.m_M[12]*c_Mat4.m_t1.m_M[2]*c_Mat4.m_t1.m_M[5];
	this.m_M[3]=-c_Mat4.m_t1.m_M[1]*c_Mat4.m_t1.m_M[6]*c_Mat4.m_t1.m_M[11]+c_Mat4.m_t1.m_M[1]*c_Mat4.m_t1.m_M[7]*c_Mat4.m_t1.m_M[10]+c_Mat4.m_t1.m_M[5]*c_Mat4.m_t1.m_M[2]*c_Mat4.m_t1.m_M[11]-c_Mat4.m_t1.m_M[5]*c_Mat4.m_t1.m_M[3]*c_Mat4.m_t1.m_M[10]-c_Mat4.m_t1.m_M[9]*c_Mat4.m_t1.m_M[2]*c_Mat4.m_t1.m_M[7]+c_Mat4.m_t1.m_M[9]*c_Mat4.m_t1.m_M[3]*c_Mat4.m_t1.m_M[6];
	this.m_M[7]=c_Mat4.m_t1.m_M[0]*c_Mat4.m_t1.m_M[6]*c_Mat4.m_t1.m_M[11]-c_Mat4.m_t1.m_M[0]*c_Mat4.m_t1.m_M[7]*c_Mat4.m_t1.m_M[10]-c_Mat4.m_t1.m_M[4]*c_Mat4.m_t1.m_M[2]*c_Mat4.m_t1.m_M[11]+c_Mat4.m_t1.m_M[4]*c_Mat4.m_t1.m_M[3]*c_Mat4.m_t1.m_M[10]+c_Mat4.m_t1.m_M[8]*c_Mat4.m_t1.m_M[2]*c_Mat4.m_t1.m_M[7]-c_Mat4.m_t1.m_M[8]*c_Mat4.m_t1.m_M[3]*c_Mat4.m_t1.m_M[6];
	this.m_M[11]=-c_Mat4.m_t1.m_M[0]*c_Mat4.m_t1.m_M[5]*c_Mat4.m_t1.m_M[11]+c_Mat4.m_t1.m_M[0]*c_Mat4.m_t1.m_M[7]*c_Mat4.m_t1.m_M[9]+c_Mat4.m_t1.m_M[4]*c_Mat4.m_t1.m_M[1]*c_Mat4.m_t1.m_M[11]-c_Mat4.m_t1.m_M[4]*c_Mat4.m_t1.m_M[3]*c_Mat4.m_t1.m_M[9]-c_Mat4.m_t1.m_M[8]*c_Mat4.m_t1.m_M[1]*c_Mat4.m_t1.m_M[7]+c_Mat4.m_t1.m_M[8]*c_Mat4.m_t1.m_M[3]*c_Mat4.m_t1.m_M[5];
	this.m_M[15]=c_Mat4.m_t1.m_M[0]*c_Mat4.m_t1.m_M[5]*c_Mat4.m_t1.m_M[10]-c_Mat4.m_t1.m_M[0]*c_Mat4.m_t1.m_M[6]*c_Mat4.m_t1.m_M[9]-c_Mat4.m_t1.m_M[4]*c_Mat4.m_t1.m_M[1]*c_Mat4.m_t1.m_M[10]+c_Mat4.m_t1.m_M[4]*c_Mat4.m_t1.m_M[2]*c_Mat4.m_t1.m_M[9]+c_Mat4.m_t1.m_M[8]*c_Mat4.m_t1.m_M[1]*c_Mat4.m_t1.m_M[6]-c_Mat4.m_t1.m_M[8]*c_Mat4.m_t1.m_M[2]*c_Mat4.m_t1.m_M[5];
	var t_det=c_Mat4.m_t1.m_M[0]*this.m_M[0]+c_Mat4.m_t1.m_M[1]*this.m_M[4]+c_Mat4.m_t1.m_M[2]*this.m_M[8]+c_Mat4.m_t1.m_M[3]*this.m_M[12];
	if(bb_math_Abs2(t_det)<=0.00001){
		return;
	}
	var t_invdet=1.0/t_det;
	for(var t_i=0;t_i<16;t_i=t_i+1){
		this.m_M[t_i]*=t_invdet;
	}
}
c_Mat4.prototype.p_RC=function(t_row,t_column){
	return this.m_M[t_column*4+t_row];
}
c_Mat4.prototype.p_SetRC=function(t_row,t_column,t_value){
	this.m_M[t_column*4+t_row]=t_value;
}
c_Mat4.prototype.p_Transpose=function(){
	c_Mat4.m_t1.p_Set9(this);
	for(var t_row=0;t_row<4;t_row=t_row+1){
		for(var t_column=0;t_column<4;t_column=t_column+1){
			this.p_SetRC(t_row,t_column,c_Mat4.m_t1.p_RC(t_column,t_row));
		}
	}
}
c_Mat4.prototype.p_SetFrustumLH=function(t_left,t_right,t_bottom,t_top,t_near,t_far){
	this.m_M[0]=2.0*t_near/(t_right-t_left);
	this.m_M[5]=2.0*t_near/(t_top-t_bottom);
	this.m_M[8]=(t_left+t_right)/(t_left-t_right);
	this.m_M[9]=(t_bottom+t_top)/(t_bottom-t_top);
	this.m_M[10]=(t_far+t_near)/(t_far-t_near);
	this.m_M[11]=1.0;
	this.m_M[14]=2.0*t_near*t_far/(t_near-t_far);
	this.m_M[15]=0.0;
}
c_Mat4.prototype.p_SetPerspectiveLH=function(t_fovy,t_aspect,t_near,t_far){
	var t_height=t_near*Math.tan((t_fovy*0.5)*D2R);
	var t_width=t_height*t_aspect;
	this.p_SetFrustumLH(-t_width,t_width,-t_height,t_height,t_near,t_far);
}
c_Mat4.prototype.p_SetViewerTransform=function(t_x,t_y,t_z,t_rw,t_rx,t_ry,t_rz){
	c_Mat4.m_q1.p_Set11(t_rw,t_rx,t_ry,t_rz);
	c_Mat4.m_q1.p_CalcAxis();
	this.p_SetIdentity();
	this.p_Rotate(-c_Mat4.m_q1.p_Angle(),c_Quat.m_ResultVector().m_X,c_Quat.m_ResultVector().m_Y,c_Quat.m_ResultVector().m_Z);
	this.p_Translate(-t_x,-t_y,-t_z);
}
c_Mat4.prototype.p_SetViewerTransform2=function(t_x,t_y,t_z,t_rx,t_ry,t_rz){
	c_Mat4.m_q1.p_SetEuler(t_rx,t_ry,t_rz);
	c_Mat4.m_q1.p_CalcAxis();
	this.p_SetIdentity();
	this.p_Rotate(-c_Mat4.m_q1.p_Angle(),c_Quat.m_ResultVector().m_X,c_Quat.m_ResultVector().m_Y,c_Quat.m_ResultVector().m_Z);
	this.p_Translate(-t_x,-t_y,-t_z);
}
c_Mat4.prototype.p_SetViewerTransform3=function(t_position,t_rotation){
	this.p_SetViewerTransform2(t_position.m_X,t_position.m_Y,t_position.m_Z,t_rotation.m_X,t_rotation.m_Y,t_rotation.m_Z);
}
c_Mat4.prototype.p_SetViewerTransform4=function(t_position,t_rotation){
	this.p_SetViewerTransform(t_position.m_X,t_position.m_Y,t_position.m_Z,t_rotation.m_W,t_rotation.m_X,t_rotation.m_Y,t_rotation.m_Z);
}
c_Mat4.m_ResultVector=function(){
	return c_Mat4.m_tv1;
}
function c_Quat(){
	Object.call(this);
	this.m_W=.0;
	this.m_X=.0;
	this.m_Y=.0;
	this.m_Z=.0;
}
c_Quat.m_new=function(){
	return this;
}
c_Quat.prototype.p_Set11=function(t_w,t_x,t_y,t_z){
	this.m_W=t_w;
	this.m_X=t_x;
	this.m_Y=t_y;
	this.m_Z=t_z;
}
c_Quat.prototype.p_Set12=function(t_other){
	this.m_W=t_other.m_W;
	this.m_X=t_other.m_X;
	this.m_Y=t_other.m_Y;
	this.m_Z=t_other.m_Z;
}
c_Quat.m_Create=function(t_w,t_x,t_y,t_z){
	var t_q=c_Quat.m_new.call(new c_Quat);
	t_q.p_Set11(t_w,t_x,t_y,t_z);
	return t_q;
}
c_Quat.m_Create2=function(t_other){
	var t_q=c_Quat.m_new.call(new c_Quat);
	t_q.p_Set12(t_other);
	return t_q;
}
c_Quat.m_tv=null;
c_Quat.prototype.p_CalcAxis=function(){
	var t_len=Math.sqrt(this.m_X*this.m_X+this.m_Y*this.m_Y+this.m_Z*this.m_Z);
	if(t_len==0.0){
		t_len=0.00001;
	}
	c_Quat.m_tv.p_Set7(this.m_X,this.m_Y,this.m_Z);
	c_Quat.m_tv.p_Div2(t_len);
}
c_Quat.prototype.p_Angle=function(){
	return (Math.acos(this.m_W)*R2D)*2.0;
}
c_Quat.m_ResultVector=function(){
	return c_Quat.m_tv;
}
c_Quat.prototype.p_SetEuler=function(t_x,t_y,t_z){
	var t_halfx=t_x*0.5;
	var t_halfy=t_y*0.5;
	var t_halfz=t_z*0.5;
	var t_sinyaw=Math.sin((t_halfy)*D2R);
	var t_sinpitch=Math.sin((t_halfx)*D2R);
	var t_sinroll=Math.sin((t_halfz)*D2R);
	var t_cosyaw=Math.cos((t_halfy)*D2R);
	var t_cospitch=Math.cos((t_halfx)*D2R);
	var t_cosroll=Math.cos((t_halfz)*D2R);
	this.m_W=t_cospitch*t_cosyaw*t_cosroll+t_sinpitch*t_sinyaw*t_sinroll;
	this.m_X=t_sinpitch*t_cosyaw*t_cosroll-t_cospitch*t_sinyaw*t_sinroll;
	this.m_Y=t_cospitch*t_sinyaw*t_cosroll+t_sinpitch*t_cosyaw*t_sinroll;
	this.m_Z=t_cospitch*t_cosyaw*t_sinroll-t_sinpitch*t_sinyaw*t_cosroll;
}
c_Quat.prototype.p_Mul7=function(t_other){
	var t_qw=this.m_W;
	var t_qx=this.m_X;
	var t_qy=this.m_Y;
	var t_qz=this.m_Z;
	this.m_W=t_qw*t_other.m_W-t_qx*t_other.m_X-t_qy*t_other.m_Y-t_qz*t_other.m_Z;
	this.m_X=t_qw*t_other.m_X+t_qx*t_other.m_W+t_qy*t_other.m_Z-t_qz*t_other.m_Y;
	this.m_Y=t_qw*t_other.m_Y+t_qy*t_other.m_W+t_qz*t_other.m_X-t_qx*t_other.m_Z;
	this.m_Z=t_qw*t_other.m_Z+t_qz*t_other.m_W+t_qx*t_other.m_Y-t_qy*t_other.m_X;
}
c_Quat.prototype.p_Mul4=function(t_w,t_x,t_y,t_z){
	var t_qw=this.m_W;
	var t_qx=this.m_X;
	var t_qy=this.m_Y;
	var t_qz=this.m_Z;
	this.m_W=t_qw*t_w-t_qx*t_x-t_qy*t_y-t_qz*t_z;
	this.m_X=t_qw*t_x+t_qx*t_w+t_qy*t_z-t_qz*t_y;
	this.m_Y=t_qw*t_y+t_qy*t_w+t_qz*t_x-t_qx*t_z;
	this.m_Z=t_qw*t_z+t_qz*t_w+t_qx*t_y-t_qy*t_x;
}
c_Quat.m_t1=null;
c_Quat.m_t2=null;
c_Quat.m_t3=null;
c_Quat.prototype.p_Conjugate=function(){
	this.m_X=-this.m_X;
	this.m_Y=-this.m_Y;
	this.m_Z=-this.m_Z;
}
c_Quat.prototype.p_Mul2=function(t_scalar){
	this.m_W*=t_scalar;
	this.m_X*=t_scalar;
	this.m_Y*=t_scalar;
	this.m_Z*=t_scalar;
}
c_Quat.prototype.p_Mul8=function(t_x,t_y,t_z){
	c_Quat.m_t1.p_Set12(this);
	c_Quat.m_t2.p_Set11(0.0,t_x,t_y,t_z);
	c_Quat.m_t3.p_Set12(this);
	c_Quat.m_t3.p_Conjugate();
	c_Quat.m_t1.p_Mul7(c_Quat.m_t2);
	c_Quat.m_t1.p_Mul7(c_Quat.m_t3);
	c_Quat.m_tv.p_Set7(c_Quat.m_t1.m_X,c_Quat.m_t1.m_Y,c_Quat.m_t1.m_Z);
}
c_Quat.prototype.p_Mul=function(t_vec){
	this.p_Mul8(t_vec.m_X,t_vec.m_Y,t_vec.m_Z);
}
c_Quat.prototype.p_Dot=function(t_other){
	return this.m_W*t_other.m_W+this.m_X*t_other.m_X+this.m_Y*t_other.m_Y+this.m_Z*t_other.m_Z;
}
c_Quat.prototype.p_Sum=function(t_other){
	this.m_W+=t_other.m_W;
	this.m_X+=t_other.m_X;
	this.m_Y+=t_other.m_Y;
	this.m_Z+=t_other.m_Z;
}
c_Quat.prototype.p_Div2=function(t_scalar){
	this.p_Mul2(1.0/t_scalar);
}
c_Quat.prototype.p_Normalize=function(){
	var t_mag2=this.m_W*this.m_W+this.m_X*this.m_X+this.m_Y*this.m_Y+this.m_Z*this.m_Z;
	if(t_mag2>0.00001 && bb_math_Abs2(t_mag2-1.0)>0.00001){
		this.p_Div2(Math.sqrt(t_mag2));
	}
}
c_Quat.prototype.p_Lerp=function(t_other,t_t){
	c_Quat.m_t1.p_Set12(t_other);
	c_Quat.m_t1.p_Mul2(t_t);
	this.p_Mul2(1.0-t_t);
	this.p_Sum(c_Quat.m_t1);
	this.p_Normalize();
}
c_Quat.prototype.p_Slerp=function(t_other,t_t){
	c_Quat.m_t1.p_Set12(t_other);
	var t_dot=this.p_Dot(t_other);
	if(t_dot<0.0){
		t_dot=-t_dot;
		c_Quat.m_t1.p_Mul2(-1.0);
	}
	if(t_dot<0.95){
		var t_angle=(Math.acos(t_dot)*R2D);
		c_Quat.m_t1.p_Mul2(Math.sin((t_angle*t_t)*D2R));
		this.p_Mul2(Math.sin((t_angle*(1.0-t_t))*D2R));
		this.p_Sum(c_Quat.m_t1);
		this.p_Div2(Math.sin((t_angle)*D2R));
	}else{
		this.p_Lerp(c_Quat.m_t1,t_t);
	}
}
function c_RenderList(){
	Object.call(this);
	this.m_mOps=null;
}
c_RenderList.m_mRenderLists=null;
c_RenderList.prototype.p_RenderOpForMaterial=function(t_material){
	var t_=this.m_mOps.p_ObjectEnumerator();
	while(t_.p_HasNext()){
		var t_op=t_.p_NextObject();
		if(t_op.m_mMaterial.p_IsEqual(t_material)){
			return t_op;
		}
	}
	return null;
}
c_RenderList.m_Sort=function(t_mat){
	var t_=c_RenderList.m_mRenderLists.p_ObjectEnumerator();
	while(t_.p_HasNext()){
		var t_renderList=t_.p_NextObject();
		var t_op=t_renderList.p_RenderOpForMaterial(t_mat);
		if((t_op)!=null){
			t_renderList.m_mOps.p_RemoveFirst2(t_op);
			if(t_mat.p_DepthWrite()==false){
				t_renderList.m_mOps.p_AddLast2(t_op);
			}else{
				t_renderList.m_mOps.p_AddFirst(t_op);
			}
		}
	}
}
c_RenderList.m_new=function(){
	this.m_mOps=c_List2.m_new.call(new c_List2);
	c_RenderList.m_mRenderLists.p_AddLast(this);
	return this;
}
c_RenderList.m_Create=function(){
	return c_RenderList.m_new.call(new c_RenderList);
}
c_RenderList.m_mTempArray=[];
c_RenderList.prototype.p_RenderGeomForSurface=function(t_surface,t_material,t_animMatrices){
	var t_op=this.p_RenderOpForMaterial(t_material);
	if((t_op)!=null){
		var t_=t_op.m_mGeoms.p_ObjectEnumerator();
		while(t_.p_HasNext()){
			var t_geom=t_.p_NextObject();
			if(t_geom.m_mSurface==t_surface){
				var t_differ=false;
				var t_len=bb_math_Min(t_animMatrices.length,t_geom.m_mAnimMatrices.length);
				for(var t_i=0;t_i<t_len;t_i=t_i+1){
					if(t_animMatrices[t_i]!=t_geom.m_mAnimMatrices[t_i]){
						t_differ=true;
						break;
					}
				}
				if(!t_differ){
					return t_geom;
				}
			}
		}
	}
	if(!((t_op)!=null)){
		t_op=c_RenderOp.m_new.call(new c_RenderOp,t_material);
		if(t_material.p_DepthWrite()==false){
			this.m_mOps.p_AddLast2(t_op);
		}else{
			this.m_mOps.p_AddFirst(t_op);
		}
	}
	var t_geom2=c_RenderGeom.m_new.call(new c_RenderGeom,t_op,t_surface,t_animMatrices);
	t_op.p_AddGeom(t_geom2);
	return t_geom2;
}
c_RenderList.prototype.p_AddSurface2=function(t_surface,t_transform,t_overrideMaterial){
	if(t_overrideMaterial==null){
		t_overrideMaterial=t_surface.p_Material();
	}
	this.p_RenderGeomForSurface(t_surface,t_overrideMaterial,c_RenderList.m_mTempArray).p_AddTransform(t_transform);
}
c_RenderList.prototype.p_AddSurface3=function(t_surface,t_transform,t_animMatrices,t_overrideMaterial){
	if(t_overrideMaterial==null){
		t_overrideMaterial=t_surface.p_Material();
	}
	this.p_RenderGeomForSurface(t_surface,t_overrideMaterial,t_animMatrices).p_AddTransform(t_transform);
}
c_RenderList.prototype.p_RenderGeomsForSurface=function(t_surface,t_material,t_animMatrices){
	var t_geoms=new_object_array(0);
	var t_=this.m_mOps.p_ObjectEnumerator();
	while(t_.p_HasNext()){
		var t_op=t_.p_NextObject();
		var t_2=t_op.m_mGeoms.p_ObjectEnumerator();
		while(t_2.p_HasNext()){
			var t_geom=t_2.p_NextObject();
			if(t_geom.m_mSurface==t_surface){
				var t_differ=false;
				var t_len=bb_math_Min(t_animMatrices.length,t_geom.m_mAnimMatrices.length);
				for(var t_i=0;t_i<t_len;t_i=t_i+1){
					if(t_animMatrices[t_i]!=t_geom.m_mAnimMatrices[t_i]){
						t_differ=true;
						break;
					}
				}
				if(!t_differ){
					t_geoms=resize_object_array(t_geoms,t_geoms.length+1);
					t_geoms[t_geoms.length-1]=t_geom;
				}
			}
		}
	}
	return t_geoms;
}
c_RenderList.prototype.p_RemoveOp=function(t_op){
	this.m_mOps.p_Remove(t_op);
}
c_RenderList.prototype.p_RemoveSurface=function(t_surface,t_transform,t_overrideMaterial){
	var t_geoms=this.p_RenderGeomsForSurface(t_surface,t_overrideMaterial,c_RenderList.m_mTempArray);
	var t_=t_geoms;
	var t_2=0;
	while(t_2<t_.length){
		var t_geom=t_[t_2];
		t_2=t_2+1;
		t_geom.p_RemoveTransform(t_transform);
		if(!t_geom.p_HasTransforms()){
			t_geom.m_mOp.p_RemoveGeom(t_geom);
			if(!t_geom.m_mOp.p_HasGeoms()){
				this.p_RemoveOp(t_geom.m_mOp);
			}
		}
	}
}
c_RenderList.prototype.p_RemoveSurface2=function(t_surface,t_transform,t_animMatrices,t_overrideMaterial){
	var t_geoms=this.p_RenderGeomsForSurface(t_surface,t_overrideMaterial,t_animMatrices);
	var t_=t_geoms;
	var t_2=0;
	while(t_2<t_.length){
		var t_geom=t_[t_2];
		t_2=t_2+1;
		t_geom.p_RemoveTransform(t_transform);
		if(!t_geom.p_HasTransforms()){
			t_geom.m_mOp.p_RemoveGeom(t_geom);
			if(!t_geom.m_mOp.p_HasGeoms()){
				this.p_RemoveOp(t_geom.m_mOp);
			}
		}
	}
}
c_RenderList.prototype.p_Render=function(){
	var t_numRenderCalls=0;
	var t_=this.m_mOps.p_ObjectEnumerator();
	while(t_.p_HasNext()){
		var t_op=t_.p_NextObject();
		t_numRenderCalls+=t_op.p_Render();
	}
	return t_numRenderCalls;
}
function c_List(){
	Object.call(this);
	this.m__head=(c_HeadNode.m_new.call(new c_HeadNode));
}
c_List.m_new=function(){
	return this;
}
c_List.prototype.p_AddLast=function(t_data){
	return c_Node2.m_new.call(new c_Node2,this.m__head,this.m__head.m__pred,t_data);
}
c_List.m_new2=function(t_data){
	var t_=t_data;
	var t_2=0;
	while(t_2<t_.length){
		var t_t=t_[t_2];
		t_2=t_2+1;
		this.p_AddLast(t_t);
	}
	return this;
}
c_List.prototype.p_ObjectEnumerator=function(){
	return c_Enumerator.m_new.call(new c_Enumerator,this);
}
function c_Node2(){
	Object.call(this);
	this.m__succ=null;
	this.m__pred=null;
	this.m__data=null;
}
c_Node2.m_new=function(t_succ,t_pred,t_data){
	this.m__succ=t_succ;
	this.m__pred=t_pred;
	this.m__succ.m__pred=this;
	this.m__pred.m__succ=this;
	this.m__data=t_data;
	return this;
}
c_Node2.m_new2=function(){
	return this;
}
function c_HeadNode(){
	c_Node2.call(this);
}
c_HeadNode.prototype=extend_class(c_Node2);
c_HeadNode.m_new=function(){
	c_Node2.m_new2.call(this);
	this.m__succ=(this);
	this.m__pred=(this);
	return this;
}
function c_Enumerator(){
	Object.call(this);
	this.m__list=null;
	this.m__curr=null;
}
c_Enumerator.m_new=function(t_list){
	this.m__list=t_list;
	this.m__curr=t_list.m__head.m__succ;
	return this;
}
c_Enumerator.m_new2=function(){
	return this;
}
c_Enumerator.prototype.p_HasNext=function(){
	while(this.m__curr.m__succ.m__pred!=this.m__curr){
		this.m__curr=this.m__curr.m__succ;
	}
	return this.m__curr!=this.m__list.m__head;
}
c_Enumerator.prototype.p_NextObject=function(){
	var t_data=this.m__curr.m__data;
	this.m__curr=this.m__curr.m__succ;
	return t_data;
}
function c_RenderOp(){
	Object.call(this);
	this.m_mMaterial=null;
	this.m_mGeoms=null;
}
c_RenderOp.m_new=function(t_material){
	this.m_mMaterial=c_Material.m_Create2(t_material,null);
	this.m_mGeoms=c_List5.m_new.call(new c_List5);
	return this;
}
c_RenderOp.m_new2=function(){
	return this;
}
c_RenderOp.prototype.p_AddGeom=function(t_geom){
	this.m_mGeoms.p_AddLast5(t_geom);
}
c_RenderOp.prototype.p_RemoveGeom=function(t_geom){
	this.m_mGeoms.p_Remove3(t_geom);
}
c_RenderOp.prototype.p_HasGeoms=function(){
	return !this.m_mGeoms.p_IsEmpty();
}
c_RenderOp.prototype.p_Render=function(){
	var t_numRenderCalls=0;
	this.m_mMaterial.p_Prepare();
	var t_=this.m_mGeoms.p_ObjectEnumerator();
	while(t_.p_HasNext()){
		var t_geom=t_.p_NextObject();
		t_numRenderCalls+=t_geom.p_Render();
	}
	return t_numRenderCalls;
}
function c_List2(){
	Object.call(this);
	this.m__head=(c_HeadNode2.m_new.call(new c_HeadNode2));
}
c_List2.prototype.p_ObjectEnumerator=function(){
	return c_Enumerator2.m_new.call(new c_Enumerator2,this);
}
c_List2.prototype.p_RemoveFirst=function(){
	var t_data=this.m__head.m__succ.m__data;
	this.m__head.m__succ.p_Remove2();
	return t_data;
}
c_List2.prototype.p_Equals=function(t_lhs,t_rhs){
	return t_lhs==t_rhs;
}
c_List2.prototype.p_Find=function(t_value,t_start){
	while(t_start!=this.m__head){
		if(this.p_Equals(t_value,t_start.m__data)){
			return t_start;
		}
		t_start=t_start.m__succ;
	}
	return null;
}
c_List2.prototype.p_Find2=function(t_value){
	return this.p_Find(t_value,this.m__head.m__succ);
}
c_List2.prototype.p_RemoveFirst2=function(t_value){
	var t_node=this.p_Find2(t_value);
	if((t_node)!=null){
		t_node.p_Remove2();
	}
}
c_List2.prototype.p_AddLast2=function(t_data){
	return c_Node3.m_new.call(new c_Node3,this.m__head,this.m__head.m__pred,t_data);
}
c_List2.prototype.p_AddFirst=function(t_data){
	return c_Node3.m_new.call(new c_Node3,this.m__head.m__succ,this.m__head,t_data);
}
c_List2.m_new=function(){
	return this;
}
c_List2.m_new2=function(t_data){
	var t_=t_data;
	var t_2=0;
	while(t_2<t_.length){
		var t_t=t_[t_2];
		t_2=t_2+1;
		this.p_AddLast2(t_t);
	}
	return this;
}
c_List2.prototype.p_RemoveEach=function(t_value){
	var t_node=this.m__head.m__succ;
	while(t_node!=this.m__head){
		var t_succ=t_node.m__succ;
		if(this.p_Equals(t_node.m__data,t_value)){
			t_node.p_Remove2();
		}
		t_node=t_succ;
	}
	return 0;
}
c_List2.prototype.p_Remove=function(t_value){
	this.p_RemoveEach(t_value);
}
function c_Enumerator2(){
	Object.call(this);
	this.m__list=null;
	this.m__curr=null;
}
c_Enumerator2.m_new=function(t_list){
	this.m__list=t_list;
	this.m__curr=t_list.m__head.m__succ;
	return this;
}
c_Enumerator2.m_new2=function(){
	return this;
}
c_Enumerator2.prototype.p_HasNext=function(){
	while(this.m__curr.m__succ.m__pred!=this.m__curr){
		this.m__curr=this.m__curr.m__succ;
	}
	return this.m__curr!=this.m__list.m__head;
}
c_Enumerator2.prototype.p_NextObject=function(){
	var t_data=this.m__curr.m__data;
	this.m__curr=this.m__curr.m__succ;
	return t_data;
}
function c_Node3(){
	Object.call(this);
	this.m__succ=null;
	this.m__pred=null;
	this.m__data=null;
}
c_Node3.m_new=function(t_succ,t_pred,t_data){
	this.m__succ=t_succ;
	this.m__pred=t_pred;
	this.m__succ.m__pred=this;
	this.m__pred.m__succ=this;
	this.m__data=t_data;
	return this;
}
c_Node3.m_new2=function(){
	return this;
}
c_Node3.prototype.p_Remove2=function(){
	this.m__succ.m__pred=this.m__pred;
	this.m__pred.m__succ=this.m__succ;
	return 0;
}
function c_HeadNode2(){
	c_Node3.call(this);
}
c_HeadNode2.prototype=extend_class(c_Node3);
c_HeadNode2.m_new=function(){
	c_Node3.m_new2.call(this);
	this.m__succ=(this);
	this.m__pred=(this);
	return this;
}
function c_Framebuffer(){
	Object.call(this);
	this.m_mColorTex=null;
	this.m_mDepthBuffer=0;
	this.m_mHandle=0;
}
c_Framebuffer.m_new=function(){
	return this;
}
c_Framebuffer.m_Create=function(t_width,t_height,t_depthBuffer){
	var t_fb=c_Framebuffer.m_new.call(new c_Framebuffer);
	t_fb.m_mColorTex=c_Texture.m_Create(t_width,t_height);
	if(t_depthBuffer){
		t_fb.m_mDepthBuffer=c_Renderer.m_CreateRenderbuffer(t_width,t_height);
	}
	t_fb.m_mHandle=c_Renderer.m_CreateFramebuffer(t_fb.m_mColorTex.p_Handle(),t_fb.m_mDepthBuffer);
	return t_fb;
}
c_Framebuffer.prototype.p_Set13=function(){
	c_Renderer.m_SetFramebuffer(this.m_mHandle);
}
c_Framebuffer.prototype.p_ColorTexture=function(){
	return this.m_mColorTex;
}
c_Framebuffer.m_SetScreen=function(){
	c_Renderer.m_SetFramebuffer(0);
}
function c_Node4(){
	Object.call(this);
	this.m_key="";
	this.m_right=null;
	this.m_left=null;
	this.m_value=null;
	this.m_color=0;
	this.m_parent=null;
}
c_Node4.m_new=function(t_key,t_value,t_color,t_parent){
	this.m_key=t_key;
	this.m_value=t_value;
	this.m_color=t_color;
	this.m_parent=t_parent;
	return this;
}
c_Node4.m_new2=function(){
	return this;
}
function c_Stream(){
	Object.call(this);
}
c_Stream.m_new=function(){
	return this;
}
c_Stream.prototype.p_Read=function(t_buffer,t_offset,t_count){
}
c_Stream.prototype.p_ReadError=function(){
	throw c_StreamReadError.m_new.call(new c_StreamReadError,this);
}
c_Stream.prototype.p_ReadAll=function(t_buffer,t_offset,t_count){
	while(t_count>0){
		var t_n=this.p_Read(t_buffer,t_offset,t_count);
		if(t_n<=0){
			this.p_ReadError();
		}
		t_offset+=t_n;
		t_count-=t_n;
	}
}
c_Stream.prototype.p_ReadAll2=function(){
	var t_bufs=c_Stack2.m_new.call(new c_Stack2);
	var t_buf=c_DataBuffer.m_new.call(new c_DataBuffer,4096,false);
	var t_off=0;
	var t_len=0;
	do{
		var t_n=this.p_Read(t_buf,t_off,4096-t_off);
		if(t_n<=0){
			break;
		}
		t_off+=t_n;
		t_len+=t_n;
		if(t_off==4096){
			t_off=0;
			t_bufs.p_Push4(t_buf);
			t_buf=c_DataBuffer.m_new.call(new c_DataBuffer,4096,false);
		}
	}while(!(false));
	var t_data=c_DataBuffer.m_new.call(new c_DataBuffer,t_len,false);
	t_off=0;
	var t_=t_bufs.p_ObjectEnumerator();
	while(t_.p_HasNext()){
		var t_tbuf=t_.p_NextObject();
		t_tbuf.p_CopyBytes(0,t_data,t_off,4096);
		t_tbuf.Discard();
		t_off+=4096;
	}
	t_buf.p_CopyBytes(0,t_data,t_off,t_len-t_off);
	t_buf.Discard();
	return t_data;
}
c_Stream.prototype.p_ReadString=function(t_count,t_encoding){
	var t_buf=c_DataBuffer.m_new.call(new c_DataBuffer,t_count,false);
	this.p_ReadAll(t_buf,0,t_count);
	return t_buf.p_PeekString2(0,t_encoding);
}
c_Stream.prototype.p_ReadString2=function(t_encoding){
	var t_buf=this.p_ReadAll2();
	return t_buf.p_PeekString2(0,t_encoding);
}
c_Stream.m__tmp=null;
c_Stream.prototype.p_ReadInt=function(){
	this.p_ReadAll(c_Stream.m__tmp,0,4);
	return c_Stream.m__tmp.PeekInt(0);
}
c_Stream.prototype.p_ReadShort=function(){
	this.p_ReadAll(c_Stream.m__tmp,0,2);
	return c_Stream.m__tmp.PeekShort(0);
}
c_Stream.prototype.p_ReadFloat=function(){
	this.p_ReadAll(c_Stream.m__tmp,0,4);
	return c_Stream.m__tmp.PeekFloat(0);
}
c_Stream.prototype.p_Close=function(){
}
c_Stream.prototype.p_ReadByte=function(){
	this.p_ReadAll(c_Stream.m__tmp,0,1);
	return c_Stream.m__tmp.PeekByte(0);
}
function c_DataStream(){
	c_Stream.call(this);
	this.m__buffer=null;
	this.m__offset=0;
	this.m__length=0;
	this.m__position=0;
}
c_DataStream.prototype=extend_class(c_Stream);
c_DataStream.m_new=function(t_buffer,t_offset){
	c_Stream.m_new.call(this);
	this.m__buffer=t_buffer;
	this.m__offset=t_offset;
	this.m__length=t_buffer.Length()-t_offset;
	return this;
}
c_DataStream.m_new2=function(t_buffer,t_offset,t_length){
	c_Stream.m_new.call(this);
	this.m__buffer=t_buffer;
	this.m__offset=t_offset;
	this.m__length=t_length;
	return this;
}
c_DataStream.m_new3=function(){
	c_Stream.m_new.call(this);
	return this;
}
c_DataStream.prototype.p_Close=function(){
	if((this.m__buffer)!=null){
		this.m__buffer=null;
		this.m__offset=0;
		this.m__length=0;
		this.m__position=0;
	}
}
c_DataStream.prototype.p_Read=function(t_buf,t_offset,t_count){
	if(this.m__position+t_count>this.m__length){
		t_count=this.m__length-this.m__position;
	}
	this.m__buffer.p_CopyBytes(this.m__offset+this.m__position,t_buf,t_offset,t_count);
	this.m__position+=t_count;
	return t_count;
}
function c_StreamError(){
	ThrowableObject.call(this);
	this.m__stream=null;
}
c_StreamError.prototype=extend_class(ThrowableObject);
c_StreamError.m_new=function(t_stream){
	this.m__stream=t_stream;
	return this;
}
c_StreamError.m_new2=function(){
	return this;
}
function c_StreamReadError(){
	c_StreamError.call(this);
}
c_StreamReadError.prototype=extend_class(c_StreamError);
c_StreamReadError.m_new=function(t_stream){
	c_StreamError.m_new.call(this,t_stream);
	return this;
}
c_StreamReadError.m_new2=function(){
	c_StreamError.m_new2.call(this);
	return this;
}
function c_Stack2(){
	Object.call(this);
	this.m_data=[];
	this.m_length=0;
}
c_Stack2.m_new=function(){
	return this;
}
c_Stack2.m_new2=function(t_data){
	this.m_data=t_data.slice(0);
	this.m_length=t_data.length;
	return this;
}
c_Stack2.prototype.p_Push4=function(t_value){
	if(this.m_length==this.m_data.length){
		this.m_data=resize_object_array(this.m_data,this.m_length*2+10);
	}
	this.m_data[this.m_length]=t_value;
	this.m_length+=1;
}
c_Stack2.prototype.p_Push5=function(t_values,t_offset,t_count){
	for(var t_i=0;t_i<t_count;t_i=t_i+1){
		this.p_Push4(t_values[t_offset+t_i]);
	}
}
c_Stack2.prototype.p_Push6=function(t_values,t_offset){
	this.p_Push5(t_values,t_offset,t_values.length-t_offset);
}
c_Stack2.prototype.p_ObjectEnumerator=function(){
	return c_Enumerator3.m_new.call(new c_Enumerator3,this);
}
c_Stack2.m_NIL=null;
c_Stack2.prototype.p_Length2=function(t_newlength){
	if(t_newlength<this.m_length){
		for(var t_i=t_newlength;t_i<this.m_length;t_i=t_i+1){
			this.m_data[t_i]=c_Stack2.m_NIL;
		}
	}else{
		if(t_newlength>this.m_data.length){
			this.m_data=resize_object_array(this.m_data,bb_math_Max(this.m_length*2+10,t_newlength));
		}
	}
	this.m_length=t_newlength;
}
c_Stack2.prototype.p_Length=function(){
	return this.m_length;
}
function c_Enumerator3(){
	Object.call(this);
	this.m_stack=null;
	this.m_index=0;
}
c_Enumerator3.m_new=function(t_stack){
	this.m_stack=t_stack;
	return this;
}
c_Enumerator3.m_new2=function(){
	return this;
}
c_Enumerator3.prototype.p_HasNext=function(){
	return this.m_index<this.m_stack.p_Length();
}
c_Enumerator3.prototype.p_NextObject=function(){
	this.m_index+=1;
	return this.m_stack.m_data[this.m_index-1];
}
function bb_math_Max(t_x,t_y){
	if(t_x>t_y){
		return t_x;
	}
	return t_y;
}
function bb_math_Max2(t_x,t_y){
	if(t_x>t_y){
		return t_x;
	}
	return t_y;
}
function c_Node5(){
	Object.call(this);
	this.m_key="";
	this.m_right=null;
	this.m_left=null;
	this.m_value=null;
	this.m_color=0;
	this.m_parent=null;
}
c_Node5.m_new=function(t_key,t_value,t_color,t_parent){
	this.m_key=t_key;
	this.m_value=t_value;
	this.m_color=t_color;
	this.m_parent=t_parent;
	return this;
}
c_Node5.m_new2=function(){
	return this;
}
function c_Glyph(){
	Object.call(this);
	this.m_mX=.0;
	this.m_mY=.0;
	this.m_mWidth=.0;
	this.m_mHeight=.0;
	this.m_mYOffset=.0;
}
c_Glyph.m_new=function(){
	return this;
}
function c_Entity(){
	Object.call(this);
	this.m_mParent=null;
	this.m_mChildren=null;
	this.m_mActive=false;
	this.m_mVisible=false;
	this.m_mPosition=null;
	this.m_mRotation=null;
	this.m_mScale=null;
	this.m_mTransform=null;
}
c_Entity.prototype.p_Parent=function(){
	return this.m_mParent;
}
c_Entity.prototype.p_Parent2=function(t_p){
	if(this.m_mParent!=t_p){
		if((this.m_mParent)!=null){
			this.m_mParent.m_mChildren.p_RemoveFirst3(this);
		}
		if((t_p)!=null){
			t_p.m_mChildren.p_AddLast3(this);
		}
		this.m_mParent=t_p;
	}
}
c_Entity.m_mTempMat=null;
c_Entity.prototype.p__UpdateTransform=function(){
	this.m_mTransform.p_SetTransform3(this.m_mPosition,this.m_mRotation,this.m_mScale);
	if((this.m_mParent)!=null){
		c_Entity.m_mTempMat.p_Set9(this.m_mParent.m_mTransform);
		c_Entity.m_mTempMat.p_Mul6(this.m_mTransform);
		this.m_mTransform.p_Set9(c_Entity.m_mTempMat);
	}
	var t_=this.m_mChildren.p_ObjectEnumerator();
	while(t_.p_HasNext()){
		var t_child=t_.p_NextObject();
		t_child.p__UpdateTransform();
	}
}
c_Entity.m_new=function(t_parent){
	this.p_Parent2(t_parent);
	this.m_mChildren=c_List3.m_new.call(new c_List3);
	this.m_mActive=true;
	this.m_mVisible=false;
	this.m_mPosition=c_Vec3.m_Create(0.0,0.0,0.0);
	this.m_mRotation=c_Vec3.m_Create(0.0,0.0,0.0);
	this.m_mScale=c_Vec3.m_Create(1.0,1.0,1.0);
	this.m_mTransform=c_Mat4.m_Create();
	c_World.m__AddEntity(this);
	this.p__UpdateTransform();
	return this;
}
c_Entity.m_new2=function(){
	return this;
}
c_Entity.prototype.p_Visible=function(){
	return this.m_mVisible;
}
c_Entity.prototype.p_Visible2=function(t_visible){
	this.m_mVisible=t_visible;
	var t_=this.m_mChildren.p_ObjectEnumerator();
	while(t_.p_HasNext()){
		var t_c=t_.p_NextObject();
		t_c.p_Visible2(t_visible);
	}
}
c_Entity.prototype.p_SetPosition=function(t_x,t_y,t_z){
	this.m_mPosition.p_Set7(t_x,t_y,t_z);
	this.p__UpdateTransform();
}
c_Entity.prototype.p_SetRotation2=function(t_pitch,t_yaw,t_roll){
	this.m_mRotation.p_Set7(t_pitch,t_yaw,t_roll);
	this.p__UpdateTransform();
}
c_Entity.prototype.p__Transform=function(){
	return this.m_mTransform;
}
c_Entity.prototype.p_Active=function(){
	return this.m_mActive;
}
c_Entity.prototype.p_Active2=function(t_active){
	this.m_mActive=t_active;
	var t_=this.m_mChildren.p_ObjectEnumerator();
	while(t_.p_HasNext()){
		var t_c=t_.p_NextObject();
		t_c.p_Active2(t_active);
	}
}
c_Entity.prototype.p__Update=function(){
}
c_Entity.prototype.p_WorldX=function(){
	return this.m_mTransform.m_M[12];
}
c_Entity.prototype.p_WorldZ=function(){
	return this.m_mTransform.m_M[14];
}
c_Entity.prototype.p_Yaw=function(){
	return this.m_mRotation.m_Y;
}
c_Entity.prototype.p_Yaw2=function(t_val){
	this.m_mRotation.m_Y=t_val;
	this.p__UpdateTransform();
}
c_Entity.m_mTempVec=null;
c_Entity.prototype.p_Distance=function(t_other){
	c_Entity.m_mTempVec.p_Set8(this.m_mPosition);
	c_Entity.m_mTempVec.p_Sub(t_other.m_mPosition);
	return c_Entity.m_mTempVec.p_Length();
}
c_Entity.prototype.p_Pitch=function(){
	return this.m_mRotation.m_X;
}
c_Entity.prototype.p_Pitch2=function(t_val){
	this.m_mRotation.m_X=t_val;
	this.p__UpdateTransform();
}
c_Entity.prototype.p_Roll=function(){
	return this.m_mRotation.m_Z;
}
c_Entity.prototype.p_Roll2=function(t_val){
	this.m_mRotation.m_Z=t_val;
	this.p__UpdateTransform();
}
c_Entity.prototype.p__PrepareForRender=function(){
}
c_Entity.prototype.p_WorldY=function(){
	return this.m_mTransform.m_M[13];
}
function c_Camera(){
	c_Entity.call(this);
	this.m_mVX=0;
	this.m_mVY=0;
	this.m_mVW=0;
	this.m_mVH=0;
	this.m_mClearColor=0;
	this.m_mFovY=.0;
	this.m_mRatio=.0;
	this.m_mNear=.0;
	this.m_mFar=.0;
	this.m_mOrtho=false;
	this.m_mClearMode=0;
}
c_Camera.prototype=extend_class(c_Entity);
c_Camera.m_new=function(){
	c_Entity.m_new.call(this,null);
	return this;
}
c_Camera.prototype.p_SetViewport=function(t_x,t_y,t_width,t_height){
	this.m_mVX=t_x;
	this.m_mVY=t_y;
	this.m_mVW=t_width;
	this.m_mVH=t_height;
}
c_Camera.prototype.p_FovY=function(){
	return this.m_mFovY;
}
c_Camera.prototype.p_FovY2=function(t_fovy){
	this.m_mFovY=t_fovy;
}
c_Camera.prototype.p_AspectRatio=function(){
	return this.m_mRatio;
}
c_Camera.prototype.p_AspectRatio2=function(t_ratio){
	this.m_mRatio=t_ratio;
}
c_Camera.prototype.p_Near=function(){
	return this.m_mNear;
}
c_Camera.prototype.p_Near2=function(t_near){
	this.m_mNear=t_near;
}
c_Camera.prototype.p_Far=function(){
	return this.m_mFar;
}
c_Camera.prototype.p_Far2=function(t_far){
	this.m_mFar=t_far;
}
c_Camera.prototype.p_Visible2=function(t_visible){
	if(t_visible!=c_Entity.prototype.p_Visible.call(this)){
		c_Entity.prototype.p_Visible2.call(this,t_visible);
		if(t_visible){
			c_World.m__AddCamera(this);
		}else{
			c_World.m__FreeCamera(this);
		}
	}
}
c_Camera.m_new2=function(t_parent){
	c_Entity.m_new.call(this,t_parent);
	this.p_SetViewport(0,0,bb_app_DeviceWidth(),bb_app_DeviceHeight());
	this.m_mClearColor=c_Color.m_RGB(55,155,255,255);
	this.p_FovY2(50.0);
	this.p_AspectRatio2((bb_app_DeviceWidth())/(bb_app_DeviceHeight()));
	this.p_Near2(1.0);
	this.p_Far2(1000.0);
	this.p_Visible2(true);
	return this;
}
c_Camera.m_Create=function(t_parent){
	return c_Camera.m_new2.call(new c_Camera,t_parent);
}
c_Camera.prototype.p_ClearColor=function(){
	return this.m_mClearColor;
}
c_Camera.prototype.p_ClearColor2=function(t_color){
	this.m_mClearColor=t_color;
}
c_Camera.prototype.p_ViewportWidth=function(){
	return this.m_mVW;
}
c_Camera.prototype.p_ViewportWidth2=function(t_val){
	this.m_mVW=t_val;
}
c_Camera.prototype.p_ViewportHeight=function(){
	return this.m_mVH;
}
c_Camera.prototype.p_ViewportHeight2=function(t_val){
	this.m_mVH=t_val;
}
c_Camera.m_mProjMatrix=null;
c_Camera.m_mViewMatrix=null;
c_Camera.prototype.p__PrepareForRender=function(){
	c_Renderer.m_Setup3D(this.m_mVX,this.m_mVY,this.m_mVW,this.m_mVH,false,0);
	if(this.m_mOrtho){
		var t_height=this.p_Near()*Math.tan((this.m_mFovY*0.5)*D2R);
		var t_width=t_height*this.m_mRatio;
		c_Camera.m_mProjMatrix.p_SetOrthoLH(-t_width,t_width,-t_height,t_height,this.m_mNear,this.m_mFar);
	}else{
		c_Camera.m_mProjMatrix.p_SetPerspectiveLH(this.m_mFovY,this.m_mRatio,this.m_mNear,this.m_mFar);
	}
	c_Renderer.m_SetProjectionMatrix(c_Camera.m_mProjMatrix);
	c_Camera.m_mViewMatrix.p_SetViewerTransform2(this.p_WorldX(),this.p_WorldY(),this.p_WorldZ(),this.p_Pitch(),this.p_Yaw(),this.p_Roll());
	c_Renderer.m_SetViewMatrix(c_Camera.m_mViewMatrix);
	c_Renderer.m_ClearDepthBuffer();
	var t_1=this.m_mClearMode;
	if(t_1==0){
		c_Renderer.m_ClearColorBuffer(this.p_ClearColor());
	}else{
		if(t_1==1){
			c_World.m__DrawSkybox(this.p_WorldX(),this.p_WorldY(),this.p_WorldZ());
		}
	}
}
function c_List3(){
	Object.call(this);
	this.m__head=(c_HeadNode3.m_new.call(new c_HeadNode3));
}
c_List3.prototype.p_RemoveFirst=function(){
	var t_data=this.m__head.m__succ.m__data;
	this.m__head.m__succ.p_Remove2();
	return t_data;
}
c_List3.prototype.p_Equals2=function(t_lhs,t_rhs){
	return t_lhs==t_rhs;
}
c_List3.prototype.p_Find3=function(t_value,t_start){
	while(t_start!=this.m__head){
		if(this.p_Equals2(t_value,t_start.m__data)){
			return t_start;
		}
		t_start=t_start.m__succ;
	}
	return null;
}
c_List3.prototype.p_Find4=function(t_value){
	return this.p_Find3(t_value,this.m__head.m__succ);
}
c_List3.prototype.p_RemoveFirst3=function(t_value){
	var t_node=this.p_Find4(t_value);
	if((t_node)!=null){
		t_node.p_Remove2();
	}
}
c_List3.prototype.p_AddLast3=function(t_data){
	return c_Node6.m_new.call(new c_Node6,this.m__head,this.m__head.m__pred,t_data);
}
c_List3.m_new=function(){
	return this;
}
c_List3.m_new2=function(t_data){
	var t_=t_data;
	var t_2=0;
	while(t_2<t_.length){
		var t_t=t_[t_2];
		t_2=t_2+1;
		this.p_AddLast3(t_t);
	}
	return this;
}
c_List3.prototype.p_ObjectEnumerator=function(){
	return c_Enumerator4.m_new.call(new c_Enumerator4,this);
}
c_List3.prototype.p_Contains3=function(t_value){
	var t_node=this.m__head.m__succ;
	while(t_node!=this.m__head){
		if(this.p_Equals2(t_node.m__data,t_value)){
			return true;
		}
		t_node=t_node.m__succ;
	}
	return false;
}
function c_Node6(){
	Object.call(this);
	this.m__succ=null;
	this.m__pred=null;
	this.m__data=null;
}
c_Node6.m_new=function(t_succ,t_pred,t_data){
	this.m__succ=t_succ;
	this.m__pred=t_pred;
	this.m__succ.m__pred=this;
	this.m__pred.m__succ=this;
	this.m__data=t_data;
	return this;
}
c_Node6.m_new2=function(){
	return this;
}
c_Node6.prototype.p_Remove2=function(){
	this.m__succ.m__pred=this.m__pred;
	this.m__pred.m__succ=this.m__succ;
	return 0;
}
function c_HeadNode3(){
	c_Node6.call(this);
}
c_HeadNode3.prototype=extend_class(c_Node6);
c_HeadNode3.m_new=function(){
	c_Node6.m_new2.call(this);
	this.m__succ=(this);
	this.m__pred=(this);
	return this;
}
function c_Enumerator4(){
	Object.call(this);
	this.m__list=null;
	this.m__curr=null;
}
c_Enumerator4.m_new=function(t_list){
	this.m__list=t_list;
	this.m__curr=t_list.m__head.m__succ;
	return this;
}
c_Enumerator4.m_new2=function(){
	return this;
}
c_Enumerator4.prototype.p_HasNext=function(){
	while(this.m__curr.m__succ.m__pred!=this.m__curr){
		this.m__curr=this.m__curr.m__succ;
	}
	return this.m__curr!=this.m__list.m__head;
}
c_Enumerator4.prototype.p_NextObject=function(){
	var t_data=this.m__curr.m__data;
	this.m__curr=this.m__curr.m__succ;
	return t_data;
}
function c_List4(){
	Object.call(this);
	this.m__head=(c_HeadNode4.m_new.call(new c_HeadNode4));
}
c_List4.m_new=function(){
	return this;
}
c_List4.prototype.p_AddLast4=function(t_data){
	return c_Node7.m_new.call(new c_Node7,this.m__head,this.m__head.m__pred,t_data);
}
c_List4.m_new2=function(t_data){
	var t_=t_data;
	var t_2=0;
	while(t_2<t_.length){
		var t_t=t_[t_2];
		t_2=t_2+1;
		this.p_AddLast4(t_t);
	}
	return this;
}
c_List4.prototype.p_RemoveFirst=function(){
	var t_data=this.m__head.m__succ.m__data;
	this.m__head.m__succ.p_Remove2();
	return t_data;
}
c_List4.prototype.p_Equals3=function(t_lhs,t_rhs){
	return t_lhs==t_rhs;
}
c_List4.prototype.p_Find5=function(t_value,t_start){
	while(t_start!=this.m__head){
		if(this.p_Equals3(t_value,t_start.m__data)){
			return t_start;
		}
		t_start=t_start.m__succ;
	}
	return null;
}
c_List4.prototype.p_Find6=function(t_value){
	return this.p_Find5(t_value,this.m__head.m__succ);
}
c_List4.prototype.p_RemoveFirst4=function(t_value){
	var t_node=this.p_Find6(t_value);
	if((t_node)!=null){
		t_node.p_Remove2();
	}
}
c_List4.prototype.p_ObjectEnumerator=function(){
	return c_Enumerator7.m_new.call(new c_Enumerator7,this);
}
function c_Node7(){
	Object.call(this);
	this.m__succ=null;
	this.m__pred=null;
	this.m__data=null;
}
c_Node7.m_new=function(t_succ,t_pred,t_data){
	this.m__succ=t_succ;
	this.m__pred=t_pred;
	this.m__succ.m__pred=this;
	this.m__pred.m__succ=this;
	this.m__data=t_data;
	return this;
}
c_Node7.m_new2=function(){
	return this;
}
c_Node7.prototype.p_Remove2=function(){
	this.m__succ.m__pred=this.m__pred;
	this.m__pred.m__succ=this.m__succ;
	return 0;
}
function c_HeadNode4(){
	c_Node7.call(this);
}
c_HeadNode4.prototype=extend_class(c_Node7);
c_HeadNode4.m_new=function(){
	c_Node7.m_new2.call(this);
	this.m__succ=(this);
	this.m__pred=(this);
	return this;
}
function c_Node8(){
	Object.call(this);
	this.m_key="";
	this.m_right=null;
	this.m_left=null;
	this.m_value=null;
	this.m_color=0;
	this.m_parent=null;
}
c_Node8.m_new=function(t_key,t_value,t_color,t_parent){
	this.m_key=t_key;
	this.m_value=t_value;
	this.m_color=t_color;
	this.m_parent=t_parent;
	return this;
}
c_Node8.m_new2=function(){
	return this;
}
function bb_filepath_ExtractDir(t_path){
	var t_i=t_path.lastIndexOf("/");
	if(t_i==-1){
		t_i=t_path.lastIndexOf("\\");
	}
	if(t_i!=-1){
		return t_path.slice(0,t_i);
	}
	return "";
}
function bb_math_Clamp(t_n,t_min,t_max){
	if(t_n<t_min){
		return t_min;
	}
	if(t_n>t_max){
		return t_max;
	}
	return t_n;
}
function bb_math_Clamp2(t_n,t_min,t_max){
	if(t_n<t_min){
		return t_min;
	}
	if(t_n>t_max){
		return t_max;
	}
	return t_n;
}
function c_Model(){
	c_Entity.call(this);
	this.m_mMesh=null;
	this.m_mMaterials=[];
	this.m_mAnimMatrices=[];
	this.m_mAnimFPS=.0;
	this.m_mCurrentFrame=.0;
	this.implments={c_IMaterialDelegate:1};
}
c_Model.prototype=extend_class(c_Entity);
c_Model.m_new=function(){
	c_Entity.m_new.call(this,null);
	return this;
}
c_Model.prototype.p_Visible=function(){
	return c_Entity.prototype.p_Visible.call(this);
}
c_Model.prototype.p_Visible2=function(t_visible){
	if(t_visible!=c_Entity.prototype.p_Visible.call(this)){
		c_Entity.prototype.p_Visible2.call(this,t_visible);
		if(t_visible){
			for(var t_i=0;t_i<this.m_mMesh.p_NumSurfaces();t_i=t_i+1){
				c_World.m__AddSurfaceToRenderList2(this.m_mMesh.p_Surface(t_i),this.p__Transform(),this.m_mAnimMatrices,this.m_mMaterials[t_i]);
			}
		}else{
			for(var t_i2=0;t_i2<this.m_mMesh.p_NumSurfaces();t_i2=t_i2+1){
				c_World.m__RemoveSurfaceFromRenderList2(this.m_mMesh.p_Surface(t_i2),this.p__Transform(),this.m_mAnimMatrices,this.m_mMaterials[t_i2]);
			}
		}
	}
}
c_Model.prototype.p_Active=function(){
	return c_Entity.prototype.p_Active.call(this);
}
c_Model.prototype.p_Active2=function(t_active){
	if(t_active!=c_Entity.prototype.p_Active.call(this)){
		c_Entity.prototype.p_Active2.call(this,t_active);
		if(t_active){
			c_World.m__EntityNeedsUpdate((this),true);
		}else{
			c_World.m__EntityNeedsUpdate((this),false);
		}
	}
}
c_Model.m_new2=function(t_mesh,t_parent){
	c_Entity.m_new.call(this,t_parent);
	this.m_mMesh=t_mesh;
	this.m_mMaterials=new_object_array(this.m_mMesh.p_NumSurfaces());
	for(var t_i=0;t_i<this.m_mMaterials.length;t_i=t_i+1){
		this.m_mMaterials[t_i]=c_Material.m_Create2(this.m_mMesh.p_Surface(t_i).p_Material(),(this));
	}
	this.m_mAnimMatrices=new_object_array(t_mesh.p_NumBones());
	for(var t_i2=0;t_i2<this.m_mAnimMatrices.length;t_i2=t_i2+1){
		this.m_mAnimMatrices[t_i2]=c_Mat4.m_Create();
	}
	this.p_Visible2(true);
	this.p_Active2(false);
	this.p_Active2(true);
	return this;
}
c_Model.m_Create=function(t_mesh,t_parent){
	if((t_mesh)!=null){
		return c_Model.m_new2.call(new c_Model,t_mesh,t_parent);
	}else{
		return null;
	}
}
c_Model.prototype.p_MaterialChanged=function(t_mat){
	var t_index=-1;
	for(var t_i=0;t_i<this.m_mMaterials.length;t_i=t_i+1){
		if(this.m_mMaterials[t_i]==t_mat){
			t_index=t_i;
			break;
		}
	}
	if(t_index!=-1){
		c_World.m__RemoveSurfaceFromRenderList(this.m_mMesh.p_Surface(t_index),this.p__Transform(),null);
		if(this.p_Visible()){
			c_World.m__AddSurfaceToRenderList(this.m_mMesh.p_Surface(t_index),this.p__Transform(),t_mat);
		}
	}
}
c_Model.prototype.p__Update=function(){
	if(this.m_mAnimFPS!=0.0 && this.m_mAnimMatrices.length>0){
		this.m_mCurrentFrame+=this.m_mAnimFPS*c_Stats.m_DeltaTime();
		if(this.m_mCurrentFrame>(this.m_mMesh.p_NumFrames2())){
			this.m_mCurrentFrame=this.m_mCurrentFrame-(this.m_mMesh.p_NumFrames2());
		}
		if(this.m_mCurrentFrame<0.0){
			this.m_mCurrentFrame=this.m_mCurrentFrame+(this.m_mMesh.p_NumFrames2());
		}
		this.m_mMesh.p_Animate(this.m_mAnimMatrices,this.m_mCurrentFrame,0,0);
	}
}
function c_RenderGeom(){
	Object.call(this);
	this.m_mSurface=null;
	this.m_mAnimMatrices=[];
	this.m_mOp=null;
	this.m_mTransforms=null;
}
c_RenderGeom.m_new=function(t_op,t_surface,t_animMatrices){
	this.m_mOp=t_op;
	this.m_mSurface=t_surface;
	this.m_mAnimMatrices=t_animMatrices;
	this.m_mTransforms=c_List6.m_new.call(new c_List6);
	return this;
}
c_RenderGeom.m_new2=function(){
	return this;
}
c_RenderGeom.prototype.p_AddTransform=function(t_transform){
	this.m_mTransforms.p_AddLast6(t_transform);
}
c_RenderGeom.prototype.p_RemoveTransform=function(t_transform){
	this.m_mTransforms.p_RemoveFirst5(t_transform);
}
c_RenderGeom.prototype.p_HasTransforms=function(){
	return !this.m_mTransforms.p_IsEmpty();
}
c_RenderGeom.prototype.p_Render=function(){
	var t_numRenderCalls=0;
	c_Renderer.m_SetSkinned(this.m_mAnimMatrices.length>0);
	if(this.m_mAnimMatrices.length>0){
		c_Renderer.m_SetBoneMatrices(this.m_mAnimMatrices);
	}
	var t_=this.m_mTransforms.p_ObjectEnumerator();
	while(t_.p_HasNext()){
		var t_transform=t_.p_NextObject();
		c_Renderer.m_SetModelMatrix(t_transform);
		this.m_mSurface.p_Draw3();
		t_numRenderCalls+=1;
	}
	return t_numRenderCalls;
}
function c_List5(){
	Object.call(this);
	this.m__head=(c_HeadNode5.m_new.call(new c_HeadNode5));
}
c_List5.prototype.p_ObjectEnumerator=function(){
	return c_Enumerator5.m_new.call(new c_Enumerator5,this);
}
c_List5.m_new=function(){
	return this;
}
c_List5.prototype.p_AddLast5=function(t_data){
	return c_Node9.m_new.call(new c_Node9,this.m__head,this.m__head.m__pred,t_data);
}
c_List5.m_new2=function(t_data){
	var t_=t_data;
	var t_2=0;
	while(t_2<t_.length){
		var t_t=t_[t_2];
		t_2=t_2+1;
		this.p_AddLast5(t_t);
	}
	return this;
}
c_List5.prototype.p_Equals4=function(t_lhs,t_rhs){
	return t_lhs==t_rhs;
}
c_List5.prototype.p_RemoveEach2=function(t_value){
	var t_node=this.m__head.m__succ;
	while(t_node!=this.m__head){
		var t_succ=t_node.m__succ;
		if(this.p_Equals4(t_node.m__data,t_value)){
			t_node.p_Remove2();
		}
		t_node=t_succ;
	}
	return 0;
}
c_List5.prototype.p_Remove3=function(t_value){
	this.p_RemoveEach2(t_value);
}
c_List5.prototype.p_IsEmpty=function(){
	return this.m__head.m__succ==this.m__head;
}
function c_Enumerator5(){
	Object.call(this);
	this.m__list=null;
	this.m__curr=null;
}
c_Enumerator5.m_new=function(t_list){
	this.m__list=t_list;
	this.m__curr=t_list.m__head.m__succ;
	return this;
}
c_Enumerator5.m_new2=function(){
	return this;
}
c_Enumerator5.prototype.p_HasNext=function(){
	while(this.m__curr.m__succ.m__pred!=this.m__curr){
		this.m__curr=this.m__curr.m__succ;
	}
	return this.m__curr!=this.m__list.m__head;
}
c_Enumerator5.prototype.p_NextObject=function(){
	var t_data=this.m__curr.m__data;
	this.m__curr=this.m__curr.m__succ;
	return t_data;
}
function c_Node9(){
	Object.call(this);
	this.m__succ=null;
	this.m__pred=null;
	this.m__data=null;
}
c_Node9.m_new=function(t_succ,t_pred,t_data){
	this.m__succ=t_succ;
	this.m__pred=t_pred;
	this.m__succ.m__pred=this;
	this.m__pred.m__succ=this;
	this.m__data=t_data;
	return this;
}
c_Node9.m_new2=function(){
	return this;
}
c_Node9.prototype.p_Remove2=function(){
	this.m__succ.m__pred=this.m__pred;
	this.m__pred.m__succ=this.m__succ;
	return 0;
}
function c_HeadNode5(){
	c_Node9.call(this);
}
c_HeadNode5.prototype=extend_class(c_Node9);
c_HeadNode5.m_new=function(){
	c_Node9.m_new2.call(this);
	this.m__succ=(this);
	this.m__pred=(this);
	return this;
}
function bb_math_Min(t_x,t_y){
	if(t_x<t_y){
		return t_x;
	}
	return t_y;
}
function bb_math_Min2(t_x,t_y){
	if(t_x<t_y){
		return t_x;
	}
	return t_y;
}
function c_List6(){
	Object.call(this);
	this.m__head=(c_HeadNode6.m_new.call(new c_HeadNode6));
}
c_List6.m_new=function(){
	return this;
}
c_List6.prototype.p_AddLast6=function(t_data){
	return c_Node10.m_new.call(new c_Node10,this.m__head,this.m__head.m__pred,t_data);
}
c_List6.m_new2=function(t_data){
	var t_=t_data;
	var t_2=0;
	while(t_2<t_.length){
		var t_t=t_[t_2];
		t_2=t_2+1;
		this.p_AddLast6(t_t);
	}
	return this;
}
c_List6.prototype.p_RemoveFirst=function(){
	var t_data=this.m__head.m__succ.m__data;
	this.m__head.m__succ.p_Remove2();
	return t_data;
}
c_List6.prototype.p_Equals5=function(t_lhs,t_rhs){
	return t_lhs==t_rhs;
}
c_List6.prototype.p_Find7=function(t_value,t_start){
	while(t_start!=this.m__head){
		if(this.p_Equals5(t_value,t_start.m__data)){
			return t_start;
		}
		t_start=t_start.m__succ;
	}
	return null;
}
c_List6.prototype.p_Find8=function(t_value){
	return this.p_Find7(t_value,this.m__head.m__succ);
}
c_List6.prototype.p_RemoveFirst5=function(t_value){
	var t_node=this.p_Find8(t_value);
	if((t_node)!=null){
		t_node.p_Remove2();
	}
}
c_List6.prototype.p_IsEmpty=function(){
	return this.m__head.m__succ==this.m__head;
}
c_List6.prototype.p_ObjectEnumerator=function(){
	return c_Enumerator8.m_new.call(new c_Enumerator8,this);
}
function c_Node10(){
	Object.call(this);
	this.m__succ=null;
	this.m__pred=null;
	this.m__data=null;
}
c_Node10.m_new=function(t_succ,t_pred,t_data){
	this.m__succ=t_succ;
	this.m__pred=t_pred;
	this.m__succ.m__pred=this;
	this.m__pred.m__succ=this;
	this.m__data=t_data;
	return this;
}
c_Node10.m_new2=function(){
	return this;
}
c_Node10.prototype.p_Remove2=function(){
	this.m__succ.m__pred=this.m__pred;
	this.m__pred.m__succ=this.m__succ;
	return 0;
}
function c_HeadNode6(){
	c_Node10.call(this);
}
c_HeadNode6.prototype=extend_class(c_Node10);
c_HeadNode6.m_new=function(){
	c_Node10.m_new2.call(this);
	this.m__succ=(this);
	this.m__pred=(this);
	return this;
}
function c_Light(){
	c_Entity.call(this);
	this.m_mType=0;
	this.m_mColor=0;
	this.m_mRadius=.0;
	this.m_mNumber=0;
}
c_Light.prototype=extend_class(c_Entity);
c_Light.m_new=function(){
	c_Entity.m_new.call(this,null);
	return this;
}
c_Light.prototype.p_Visible=function(){
	return c_Entity.prototype.p_Visible.call(this);
}
c_Light.prototype.p_Visible2=function(t_visible){
	if(t_visible!=c_Entity.prototype.p_Visible.call(this)){
		c_Entity.prototype.p_Visible2.call(this,t_visible);
		if(t_visible){
			c_World.m__AddLight(this);
		}else{
			c_World.m__FreeLight(this);
		}
	}
}
c_Light.m_new2=function(t_type,t_parent){
	c_Entity.m_new.call(this,t_parent);
	this.m_mType=t_type;
	this.m_mColor=-1;
	this.m_mRadius=100.0;
	this.p_Visible2(true);
	return this;
}
c_Light.m_Create=function(t_type,t_parent){
	if(t_type>=0 && t_type<=1){
		return c_Light.m_new2.call(new c_Light,t_type,t_parent);
	}else{
		return null;
	}
}
c_Light.prototype.p_Color2=function(){
	return this.m_mColor;
}
c_Light.prototype.p_Color=function(t_color){
	this.m_mColor=t_color;
}
c_Light.prototype.p__Number=function(){
	return this.m_mNumber;
}
c_Light.prototype.p__Number2=function(t_number){
	this.m_mNumber=t_number;
}
c_Light.m_mTempQuat=null;
c_Light.prototype.p__PrepareForRender=function(){
	if(this.m_mType==0){
		c_Light.m_mTempQuat.p_SetEuler(this.p_Pitch(),this.p_Yaw(),this.p_Roll());
		c_Light.m_mTempQuat.p_Mul8(0.0,0.0,-1.0);
		c_Renderer.m_ViewMatrix().p_Mul4(c_Quat.m_ResultVector().m_X,c_Quat.m_ResultVector().m_Y,c_Quat.m_ResultVector().m_Z,0.0);
		c_Renderer.m_SetLight(this.m_mNumber,c_Mat4.m_ResultVector().m_X,c_Mat4.m_ResultVector().m_Y,c_Mat4.m_ResultVector().m_Z,0.0,(c_Color.m_Red(this.m_mColor))/255.0,(c_Color.m_Green(this.m_mColor))/255.0,(c_Color.m_Blue(this.m_mColor))/255.0,this.m_mRadius);
	}else{
		c_Renderer.m_ViewMatrix().p_Mul4(this.p_WorldX(),this.p_WorldY(),this.p_WorldZ(),1.0);
		c_Renderer.m_SetLight(this.m_mNumber,c_Mat4.m_ResultVector().m_X,c_Mat4.m_ResultVector().m_Y,c_Mat4.m_ResultVector().m_Z,1.0,(c_Color.m_Red(this.m_mColor))/255.0,(c_Color.m_Green(this.m_mColor))/255.0,(c_Color.m_Blue(this.m_mColor))/255.0,this.m_mRadius);
	}
}
function c_List7(){
	Object.call(this);
	this.m__head=(c_HeadNode7.m_new.call(new c_HeadNode7));
}
c_List7.m_new=function(){
	return this;
}
c_List7.prototype.p_AddLast7=function(t_data){
	return c_Node11.m_new.call(new c_Node11,this.m__head,this.m__head.m__pred,t_data);
}
c_List7.m_new2=function(t_data){
	var t_=t_data;
	var t_2=0;
	while(t_2<t_.length){
		var t_t=t_[t_2];
		t_2=t_2+1;
		this.p_AddLast7(t_t);
	}
	return this;
}
c_List7.prototype.p_RemoveFirst=function(){
	var t_data=this.m__head.m__succ.m__data;
	this.m__head.m__succ.p_Remove2();
	return t_data;
}
c_List7.prototype.p_Equals6=function(t_lhs,t_rhs){
	return t_lhs==t_rhs;
}
c_List7.prototype.p_Find9=function(t_value,t_start){
	while(t_start!=this.m__head){
		if(this.p_Equals6(t_value,t_start.m__data)){
			return t_start;
		}
		t_start=t_start.m__succ;
	}
	return null;
}
c_List7.prototype.p_Find10=function(t_value){
	return this.p_Find9(t_value,this.m__head.m__succ);
}
c_List7.prototype.p_RemoveFirst6=function(t_value){
	var t_node=this.p_Find10(t_value);
	if((t_node)!=null){
		t_node.p_Remove2();
	}
}
c_List7.prototype.p_Count=function(){
	var t_n=0;
	var t_node=this.m__head.m__succ;
	while(t_node!=this.m__head){
		t_node=t_node.m__succ;
		t_n+=1;
	}
	return t_n;
}
c_List7.prototype.p_First=function(){
	return this.m__head.m__succ.m__data;
}
c_List7.prototype.p_ObjectEnumerator=function(){
	return c_Enumerator9.m_new.call(new c_Enumerator9,this);
}
function c_Node11(){
	Object.call(this);
	this.m__succ=null;
	this.m__pred=null;
	this.m__data=null;
}
c_Node11.m_new=function(t_succ,t_pred,t_data){
	this.m__succ=t_succ;
	this.m__pred=t_pred;
	this.m__succ.m__pred=this;
	this.m__pred.m__succ=this;
	this.m__data=t_data;
	return this;
}
c_Node11.m_new2=function(){
	return this;
}
c_Node11.prototype.p_Remove2=function(){
	this.m__succ.m__pred=this.m__pred;
	this.m__pred.m__succ=this.m__succ;
	return 0;
}
function c_HeadNode7(){
	c_Node11.call(this);
}
c_HeadNode7.prototype=extend_class(c_Node11);
c_HeadNode7.m_new=function(){
	c_Node11.m_new2.call(this);
	this.m__succ=(this);
	this.m__pred=(this);
	return this;
}
function c_Listener(){
	Object.call(this);
}
c_Listener.m_mListener=null;
c_Listener.m_mEmittedSounds=null;
c_Listener.m_Instance=function(){
	return c_Listener.m_mListener;
}
c_Listener.m__Update=function(){
	if(c_Listener.m_mListener!=null){
		var t_=c_Listener.m_mEmittedSounds.p_ObjectEnumerator();
		while(t_.p_HasNext()){
			var t_es=t_.p_NextObject();
			if(!t_es.p__Update()){
				c_Listener.m_mEmittedSounds.p_RemoveFirst7(t_es);
			}
		}
	}
}
function c_EmittedSound(){
	Object.call(this);
	this.m_Channel=0;
	this.m_Emitter=null;
	this.m_Radius=.0;
}
c_EmittedSound.prototype.p__Update=function(){
	var t_state=bb_audio_ChannelState(this.m_Channel);
	if(t_state==1){
		var t_angle=(Math.atan2(this.m_Emitter.p_WorldX()-c_Listener.m_Instance().p_WorldX(),this.m_Emitter.p_WorldZ()-c_Listener.m_Instance().p_WorldZ())*R2D)-c_Listener.m_Instance().p_Yaw();
		var t_pan=Math.sin((t_angle)*D2R);
		var t_vol=1.0-bb_math_Clamp2(this.m_Emitter.p_Distance(c_Listener.m_Instance())/this.m_Radius,0.0,1.0);
		bb_audio_SetChannelPan(this.m_Channel,t_pan);
		bb_audio_SetChannelVolume(this.m_Channel,t_vol);
	}else{
		if(t_state==0 || t_state==-1){
			return false;
		}
	}
	return true;
}
function c_List8(){
	Object.call(this);
	this.m__head=(c_HeadNode8.m_new.call(new c_HeadNode8));
}
c_List8.m_new=function(){
	return this;
}
c_List8.prototype.p_AddLast8=function(t_data){
	return c_Node12.m_new.call(new c_Node12,this.m__head,this.m__head.m__pred,t_data);
}
c_List8.m_new2=function(t_data){
	var t_=t_data;
	var t_2=0;
	while(t_2<t_.length){
		var t_t=t_[t_2];
		t_2=t_2+1;
		this.p_AddLast8(t_t);
	}
	return this;
}
c_List8.prototype.p_ObjectEnumerator=function(){
	return c_Enumerator6.m_new.call(new c_Enumerator6,this);
}
c_List8.prototype.p_RemoveFirst=function(){
	var t_data=this.m__head.m__succ.m__data;
	this.m__head.m__succ.p_Remove2();
	return t_data;
}
c_List8.prototype.p_Equals7=function(t_lhs,t_rhs){
	return t_lhs==t_rhs;
}
c_List8.prototype.p_Find11=function(t_value,t_start){
	while(t_start!=this.m__head){
		if(this.p_Equals7(t_value,t_start.m__data)){
			return t_start;
		}
		t_start=t_start.m__succ;
	}
	return null;
}
c_List8.prototype.p_Find12=function(t_value){
	return this.p_Find11(t_value,this.m__head.m__succ);
}
c_List8.prototype.p_RemoveFirst7=function(t_value){
	var t_node=this.p_Find12(t_value);
	if((t_node)!=null){
		t_node.p_Remove2();
	}
}
function c_Node12(){
	Object.call(this);
	this.m__succ=null;
	this.m__pred=null;
	this.m__data=null;
}
c_Node12.m_new=function(t_succ,t_pred,t_data){
	this.m__succ=t_succ;
	this.m__pred=t_pred;
	this.m__succ.m__pred=this;
	this.m__pred.m__succ=this;
	this.m__data=t_data;
	return this;
}
c_Node12.m_new2=function(){
	return this;
}
c_Node12.prototype.p_Remove2=function(){
	this.m__succ.m__pred=this.m__pred;
	this.m__pred.m__succ=this.m__succ;
	return 0;
}
function c_HeadNode8(){
	c_Node12.call(this);
}
c_HeadNode8.prototype=extend_class(c_Node12);
c_HeadNode8.m_new=function(){
	c_Node12.m_new2.call(this);
	this.m__succ=(this);
	this.m__pred=(this);
	return this;
}
function c_Enumerator6(){
	Object.call(this);
	this.m__list=null;
	this.m__curr=null;
}
c_Enumerator6.m_new=function(t_list){
	this.m__list=t_list;
	this.m__curr=t_list.m__head.m__succ;
	return this;
}
c_Enumerator6.m_new2=function(){
	return this;
}
c_Enumerator6.prototype.p_HasNext=function(){
	while(this.m__curr.m__succ.m__pred!=this.m__curr){
		this.m__curr=this.m__curr.m__succ;
	}
	return this.m__curr!=this.m__list.m__head;
}
c_Enumerator6.prototype.p_NextObject=function(){
	var t_data=this.m__curr.m__data;
	this.m__curr=this.m__curr.m__succ;
	return t_data;
}
function bb_audio_ChannelState(t_channel){
	return bb_audio_device.ChannelState(t_channel);
}
function bb_audio_SetChannelPan(t_channel,t_pan){
	bb_audio_device.SetPan(t_channel,t_pan);
	return 0;
}
function bb_audio_SetChannelVolume(t_channel,t_volume){
	bb_audio_device.SetVolume(t_channel,t_volume);
	return 0;
}
function c_Enumerator7(){
	Object.call(this);
	this.m__list=null;
	this.m__curr=null;
}
c_Enumerator7.m_new=function(t_list){
	this.m__list=t_list;
	this.m__curr=t_list.m__head.m__succ;
	return this;
}
c_Enumerator7.m_new2=function(){
	return this;
}
c_Enumerator7.prototype.p_HasNext=function(){
	while(this.m__curr.m__succ.m__pred!=this.m__curr){
		this.m__curr=this.m__curr.m__succ;
	}
	return this.m__curr!=this.m__list.m__head;
}
c_Enumerator7.prototype.p_NextObject=function(){
	var t_data=this.m__curr.m__data;
	this.m__curr=this.m__curr.m__succ;
	return t_data;
}
function bb_math_Abs(t_x){
	if(t_x>=0){
		return t_x;
	}
	return -t_x;
}
function bb_math_Abs2(t_x){
	if(t_x>=0.0){
		return t_x;
	}
	return -t_x;
}
function c_Enumerator8(){
	Object.call(this);
	this.m__list=null;
	this.m__curr=null;
}
c_Enumerator8.m_new=function(t_list){
	this.m__list=t_list;
	this.m__curr=t_list.m__head.m__succ;
	return this;
}
c_Enumerator8.m_new2=function(){
	return this;
}
c_Enumerator8.prototype.p_HasNext=function(){
	while(this.m__curr.m__succ.m__pred!=this.m__curr){
		this.m__curr=this.m__curr.m__succ;
	}
	return this.m__curr!=this.m__list.m__head;
}
c_Enumerator8.prototype.p_NextObject=function(){
	var t_data=this.m__curr.m__data;
	this.m__curr=this.m__curr.m__succ;
	return t_data;
}
function c_Enumerator9(){
	Object.call(this);
	this.m__list=null;
	this.m__curr=null;
}
c_Enumerator9.m_new=function(t_list){
	this.m__list=t_list;
	this.m__curr=t_list.m__head.m__succ;
	return this;
}
c_Enumerator9.m_new2=function(){
	return this;
}
c_Enumerator9.prototype.p_HasNext=function(){
	while(this.m__curr.m__succ.m__pred!=this.m__curr){
		this.m__curr=this.m__curr.m__succ;
	}
	return this.m__curr!=this.m__list.m__head;
}
c_Enumerator9.prototype.p_NextObject=function(){
	var t_data=this.m__curr.m__data;
	this.m__curr=this.m__curr.m__succ;
	return t_data;
}
function bb_math_Sgn(t_x){
	if(t_x<0){
		return -1;
	}
	return ((t_x>0)?1:0);
}
function bb_math_Sgn2(t_x){
	if(t_x<0.0){
		return -1.0;
	}
	if(t_x>0.0){
		return 1.0;
	}
	return 0.0;
}
function bbInit(){
	bb_app__app=null;
	bb_app__delegate=null;
	bb_app__game=BBGame.Game();
	bb_graphics_device=null;
	bb_graphics_context=c_GraphicsContext.m_new.call(new c_GraphicsContext);
	c_Image.m_DefaultFlags=0;
	bb_audio_device=null;
	bb_input_device=null;
	bb_app__devWidth=0;
	bb_app__devHeight=0;
	bb_app__displayModes=[];
	bb_app__desktopMode=null;
	bb_graphics_renderDevice=null;
	bb_app__updateRate=0;
	bb_random_Seed=1234;
	c_Renderer.m_mMaxLights=0;
	c_Renderer.m_mMaxBones=0;
	c_Renderer.m_mVendor="";
	c_Renderer.m_mRenderer="";
	c_Renderer.m_mVersionStr="";
	c_Renderer.m_mShadingVersionStr="";
	c_Renderer.m_mVersion=.0;
	c_Renderer.m_mShadingVersion=.0;
	c_Renderer.m_mProgramError="";
	c_Renderer.m_mDefaultProgram=null;
	c_Renderer.m_mDepthProgram=null;
	c_Renderer.m_m2DProgram=null;
	c_Renderer.m_mActiveProgram=null;
	c_Renderer.m_mEllipseBuffer=0;
	c_Renderer.m_mLineBuffer=0;
	c_Renderer.m_mRectBuffer=0;
	c_Cache.m_mStack=new_object_array(0);
	c_Stats.m_mLastMillisecs=0;
	c_Stats.m_mFpsCounter=0;
	c_Stats.m_mFpsAccum=.0;
	c_World.m_mSkybox=null;
	c_RenderList.m_mRenderLists=c_List.m_new.call(new c_List);
	c_World.m_mAmbient=0;
	c_World.m_mFogEnabled=false;
	c_World.m_mFogMin=.0;
	c_World.m_mFogMax=.0;
	c_World.m_mFogColor=0;
	c_World.m_mGlobalPixelLighting=false;
	c_World.m_mShadowsEnabled=false;
	c_World.m_mDepthHeight=.0;
	c_World.m_mDepthFar=.0;
	c_World.m_mDepthEpsilon=.0;
	c_World.m_mFramebuffer=null;
	c_Stack2.m_NIL=null;
	c_Stream.m__tmp=c_DataBuffer.m_new.call(new c_DataBuffer,4096,false);
	c_Texture.m_mSizeArr=new_number_array(2);
	c_World.m_mEntities=c_List3.m_new.call(new c_List3);
	c_Mat4.m_q1=c_Quat.m_Create(1.0,0.0,0.0,0.0);
	c_Quat.m_tv=c_Vec3.m_Create(0.0,0.0,0.0);
	c_Mat4.m_t1=c_Mat4.m_Create();
	c_Mat4.m_t2=c_Mat4.m_Create();
	c_Mat4.m_tv1=c_Vec3.m_Create(0.0,0.0,0.0);
	c_Entity.m_mTempMat=c_Mat4.m_Create();
	c_World.m_mCameras=c_List4.m_new.call(new c_List4);
	c_Mesh.m_mTempMatrix=c_Mat4.m_Create();
	c_World.m_mRenderList=c_RenderList.m_Create();
	c_RenderList.m_mTempArray=new_object_array(0);
	c_World.m_mEnabledEntities=c_List3.m_new.call(new c_List3);
	c_World.m_mLights=c_List7.m_new.call(new c_List7);
	c_Stats.m_mDeltaTime=.0;
	c_Listener.m_mListener=null;
	c_Listener.m_mEmittedSounds=c_List8.m_new.call(new c_List8);
	c_Entity.m_mTempVec=c_Vec3.m_Create(0.0,0.0,0.0);
	c_Stats.m_mFps=0;
	c_Stats.m_mRenderCalls=0;
	c_World.m_mTempQuat=c_Quat.m_Create(1.0,0.0,0.0,0.0);
	c_Quat.m_t1=c_Quat.m_Create(1.0,0.0,0.0,0.0);
	c_Quat.m_t2=c_Quat.m_Create(1.0,0.0,0.0,0.0);
	c_Quat.m_t3=c_Quat.m_Create(1.0,0.0,0.0,0.0);
	c_World.m_mDepthProj=c_Mat4.m_Create();
	c_World.m_mDepthView=c_Mat4.m_Create();
	c_Mat4.m_tv3=c_Vec3.m_Create(0.0,0.0,0.0);
	c_Mat4.m_tv2=c_Vec3.m_Create(0.0,0.0,0.0);
	c_Renderer.m_mTempMatrix=c_Mat4.m_Create();
	c_Renderer.m_mDepthBiasMatrix=c_Mat4.m_Create();
	c_Renderer.m_mProjectionMatrix=c_Mat4.m_Create();
	c_Renderer.m_mViewMatrix=c_Mat4.m_Create();
	c_Renderer.m_mInvViewMatrix=c_Mat4.m_Create();
	c_Renderer.m_mModelMatrix=c_Mat4.m_Create();
	c_Camera.m_mProjMatrix=c_Mat4.m_Create();
	c_Camera.m_mViewMatrix=c_Mat4.m_Create();
	c_World.m_mSkyboxMatrix=c_Mat4.m_Create();
	c_Light.m_mTempQuat=c_Quat.m_Create(1.0,0.0,0.0,0.0);
	c_World.m_mVisibleEntities=c_List3.m_new.call(new c_List3);
	c_Renderer.m_mTexDataBuffer=c_DataBuffer.m_new.call(new c_DataBuffer,32,true);
	c_Bone.m_mTempVec=c_Vec3.m_Create(0.0,0.0,0.0);
	c_Bone.m_mTempQuat=c_Quat.m_Create(1.0,0.0,0.0,0.0);
}
//${TRANSCODE_END}
