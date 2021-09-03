// CS4590 
// HW2
// Puyan Lotfi
// March 16th 2007
// Professor Maribeth Gandy
//
// Write up:
//
// So a few of the things that I have 
// incorporated into my ChucK program are:
//
// - Three different instruments:
// 
// 	- Mandolin
// 	- Sitar
// 	- FLute
//
// - Envelop function:
//
// 	- I took the example code with the spork,
// 	  worked from there. 
// 	- Basically I made it increase the gain
// 	  with the increment in the for loop
// 	  and I divide the note dur with some
// 	  random function. 
//
// - Other addons:
// 
// 	- I added some mouse listener events
// 	  that bassically play the flute and 
// 	  the mandolin when the mouse is clicked
// 	  and play the sitar when the mouse is draged about.
//
// Basically there is a neat exploding sound when you click
// the mouse button (cause of the flute dragging on and the 
// increase in gain in the mandolin from the envelop/spork)
// and very precise sitar sounds when you drag. If you drag
// a lot, it will sound garbled. Best thing is to experiment
// a little with how to move the mouse and how often to click 
// the buttons, until you figure out what sounds cool.
// 
// And that is all I have to say about that...
//
//

// setup mouse device
0 => int device;
// hid objects
HidIn hi;
HidMsg msg;
// try
if( !hi.openMouse( device ) ) me.exit();
<<< "mouse ready...", "" >>>;

// setup mandolin
Mandolin mandolin => JCRev revmandolin => dac;
.75 => revmandolin.gain;
.05 => revmandolin.mix;

// setup sitar
Sitar sitar => PRCRev revsitar => dac;
7 => revsitar.gain;
.15 => revsitar.mix;

// setup flute
Flute flute => PoleZero polezeroflute => JCRev revflute => dac;
.75 => revflute.gain;
.05 => revflute.mix;
1 => polezeroflute.blockZero;




/////     This is the old macdonald stuff provided by graham, 
/////     but with a few modifications

//sequence data, like a midi file
//specified as MIDI key number and relative duration
[
//old    Mac      Donald            had      a        farm
[60, 2], [60, 2], [60, 2], [55, 2], [57, 2], [57, 2], [55, 4],

	//eeee   aye      eeee     aye      ooooo    and
	[64, 2], [64, 2], [62, 2], [62, 2], [60, 6], [55, 2],

	//repeat
	[60, 2], [60, 2], [60, 2], [55, 2], [57, 2], [57, 2], [55, 4],
	[64, 2], [64, 2], [62, 2], [62, 2], [60, 6], 

	//with   a
	[55, 1], [55, 1],

	// Here is my modifications, I made it do it a few 
	// times extra. sounds cool on sitar

	//mooo   moooo    here     and      a
	[60, 2], [60, 2], [60, 2], [55, 1], [55, 1],
	[60, 2], [60, 2], [60, 2],
	//here   a        mooo
	[60, 1], [60, 1], [60, 2], 
	[60, 1], [60, 1], [60, 2],

	//mooo   moooo    here     and      a
	[60, 2], [60, 2], [60, 2], [55, 1], [55, 1],
	[60, 2], [60, 2], [60, 2],
	//here   a        mooo
	[60, 1], [60, 1], [60, 2], 
	[60, 1], [60, 1], [60, 2],

	//mooo   moooo    here     and      a
	[60, 2], [60, 2], [60, 2], [55, 1], [55, 1],
	[60, 2], [60, 2], [60, 2],
	//here   a        mooo
	[60, 1], [60, 1], [60, 2], 
	[60, 1], [60, 1], [60, 2],

	//mooo   moooo    here     and      a
	[60, 2], [60, 2], [60, 2], [55, 1], [55, 1],
	[60, 2], [60, 2], [60, 2],
	//here   a        mooo
	[60, 1], [60, 1], [60, 2], 
	[60, 1], [60, 1], [60, 2],

	//every           where    a        moooo    moooo
	[60, 1], [60, 1], [60, 1], [60, 1], [60, 2], [60, 2],

	//reprise
	[60, 2], [60, 2], [60, 2], [55, 2], [57, 2], [57, 2], [55, 4],
	[64, 2], [64, 2], [62, 2], [62, 2], [60, 6]

	] @=> int mel[][];


	while(true) { 
		// added while loop to be more
		// fun when doing things with mouse

		for (0=>int i; i<mel.cap(); i++) {
			play( mel[i][0],  Std.rand2f( .6, .9 )); 
			// play with random velocity
			mel[i][1] * .1::second => dur noteDur;
			spork ~ envFunc( noteDur );
			// I found that this envelop function stuff
			// just makes things sound bad for me... 
		}
	}

// basic play function (add more arguments as needed)
fun void play( float note, float velocity)
{
	// wait on mouse event
	hi => now;
	// loop over messages
	while( hi.recv( msg ) )
	{
		if( msg.isMouseMotion() )
		{
			Std.mtof( note ) => sitar.freq;
			velocity => sitar.noteOn;
		}
		else 
		{
			Std.mtof( note ) => flute.freq;
			velocity => flute.noteOn;	
			
			Std.mtof( note ) => mandolin.freq;
			velocity => mandolin.noteOn;
		}
	}
}


fun void envFunc(dur noteDur) {
  for (0=>int i; i<1000; i++) {
    mandolin.gain(i);
    noteDur/Std.rand2f( .6, .9 ) => now;
  }
}


