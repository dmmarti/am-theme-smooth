///////////////////////////////////////////////////////////////////////////
//
// Attract Mode Theme: Smooth
//
// This theme is used with the Attract Mode frontend
//
// It uses the Overview text files for scrolling of the game descriptions
//
// Special thanks to jedione for his help with the scrolling code
//
///////////////////////////////////////////////////////////////////////////

class UserConfig {
</ label="--------  Main theme layout  --------", help="Layout Options", order=1 /> uct1="select below";
   </ label="Select side image", help="Select image", options="Boxart,Flyer", order=2 /> sideimage="Flyer";
   </ label="Random Wheel Sounds", help="Play random sounds when navigating games wheel", options="Yes,No", order=3 /> enable_random_sound="Yes";
}

// get config and setup defaults
local my_config = fe.get_config();
local flx = fe.layout.width;
local fly = fe.layout.height;
local flw = fe.layout.width;
local flh = fe.layout.height;
fe.layout.font="blogger.ttf";

// modules
fe.load_module("fade");
fe.load_module( "animate" );
fe.load_module("scrollingtext");

// load background image
local b_art = fe.add_image("back.png", 0, 0, flw, flh );

// create surface for snap
local surface_snap = fe.add_surface( 640, 480 );
local snap = FadeArt("snap", 0, 0, 640, 480, surface_snap);
snap.trigger = Transition.EndNavigation;
snap.preserve_aspect_ratio = true;

// now position and pinch surface of snap
// adjust the below values for the game video preview snap
surface_snap.set_pos(flx*0.405, fly*0.048, flw*0.35, flh*0.45);
surface_snap.skew_y = 0;
surface_snap.skew_x = 0;
surface_snap.pinch_y = 0;
surface_snap.pinch_x = 0;
surface_snap.rotation = 0;

// wheel or system flyer art to display
local wheelart = fe.add_artwork("wheel", flx*0.8158, fly*0.0215, flw*0.15, flh*0.15);
wheelart.preserve_aspect_ratio = true;

if ( my_config["sideimage"] == "Boxart" )
{
local sideimagetype = fe.add_artwork("boxart", flx*0.815, fly*0.165, flw*0.15, flh*0.35 );
sideimagetype.preserve_aspect_ratio = true;
}

if ( my_config["sideimage"] == "Flyer" )
{
local sideimagetype = fe.add_image("flyer/[Emulator]", flx*0.82, fly*0.175, flw*0.14 flh*0.325 );
sideimagetype.preserve_aspect_ratio = true;
}

// listbox game list
local listbox = fe.add_listbox( flx*0.012, fly*0.059, flw*0.36, flh*0.88 );
listbox.rows = 30;
listbox.charsize = 24;
listbox.set_rgb( 255, 255, 255 );
listbox.bg_alpha = 0;
listbox.align = Align.Left;
listbox.selbg_alpha = 0;
listbox.sel_red = 240;
listbox.sel_green = 100;
listbox.sel_blue = 25;

// setup Overview text
// make the new surface
local surface = fe.add_surface(flw*0.6, flh*0.275  );
surface.x = flx*0.39;
surface.y = fly*0.67;

// put overview text on the new surface
local text = surface.add_text( "[Overview]", 0, 0, flx*0.587, flh );
text.word_wrap = true;
text.align = Align.TopLeft;
text.set_rgb (255, 255, 255);
text.charsize = 20;

//text.set_bg_rgb( 100, 100, 100 );
// uncoment the ubove line to visibley see the transparent text layer !
// so can u position and size in layout easier!

// calling "local text" in the animation     
local an = { when=Transition.ToNewSelection, 
//local an = { when=Transition.StartLayout, 
property="y", 
start=text.y+200 , 
end=text.y-340, 
time=55000 
loop = true,
}
animation.add( PropertyAnimation( text, an ) );

// category genre icons 
local glogo1 = fe.add_image("glogos/unknown1.png", flx*0.385, fly*0.57, flw*0.045, flh*0.055);
glogo1.trigger = Transition.EndNavigation;

class GenreImage1
{
    mode = 2;       //0 = first match, 1 = last match, 2 = random
    supported = {
        //filename : [ match1, match2 ]
        "action": [ "action","gun", "climbing" ],
        "adventure": [ "adventure" ],
        "arcade": [ "arcade" ],
        "casino": [ "casino" ],
        "computer": [ "computer" ],
        "console": [ "console" ],
        "collection": [ "collection" ],
        "fighter": [ "fighting", "fighter", "beat-'em-up" ],
        "handheld": [ "handheld" ],
		"jukebox": [ "jukebox" ],
        "platformer": [ "platformer", "platform" ],
        "mahjong": [ "mahjong" ],
        "maze": [ "maze" ],
        "paddle": [ "breakout", "paddle" ],
        "puzzle": [ "puzzle" ],
	    "pinball": [ "pinball" ],
	    "quiz": [ "quiz" ],
	    "racing": [ "racing", "driving","motorcycle" ],
        "rpg": [ "rpg", "role playing", "role-playing" ],
	    "rhythm": [ "rhythm" ],
        "shooter": [ "shooter", "shmup", "shoot-'em-up" ],
	    "simulation": [ "simulation" ],
        "sports": [ "sports", "boxing", "golf", "baseball", "football", "soccer", "tennis", "hockey" ],
        "strategy": [ "strategy"],
        "utility": [ "utility" ]
    }

    ref = null;
    constructor( image )
    {
        ref = image;
        fe.add_transition_callback( this, "transition" );
		ref.preserve_aspect_ratio = true;
    }
    
    function transition( ttype, var, ttime )
    {
        if ( ttype == Transition.ToNewSelection || ttype == Transition.ToNewList )
        {
            local cat = " " + fe.game_info(Info.Category, var).tolower();
            local matches = [];
            foreach( key, val in supported )
            {
                foreach( nickname in val )
                {
                    if ( cat.find(nickname, 0) ) matches.push(key);
                }
            }
            if ( matches.len() > 0 )
            {
                switch( mode )
                {
                    case 0:
                        ref.file_name = "glogos/" + matches[0] + "1.png";
                        break;
                    case 1:
                        ref.file_name = "glogos/" + matches[matches.len() - 1] + "1.png";
                        break;
                    case 2:
                        local random_num = floor(((rand() % 1000 ) / 1000.0) * ((matches.len() - 1) - (0 - 1)) + 0);
                        ref.file_name = "glogos/" + matches[random_num] + "1.png";
                        break;
                }
            } else
            {
                ref.file_name = "glogos/unknown1.png";
            }
        }
    }
}
GenreImage1(glogo1);

// emulator text info
local textemu = fe.add_text( "Emulator: [Emulator]", flx* 0.435, fly*0.54, flw*0.6, flh*0.025  );
textemu.set_rgb( 255, 255, 255 );
textemu.align = Align.Left;
textemu.word_wrap = false;

// year text info
local texty = fe.add_text("Year: [Year]", flx*0.435, fly*0.57, flw*0.13, flh*0.025 );
texty.set_rgb( 255, 255, 255 );
texty.align = Align.Left;

// players text info
local textp = fe.add_text("Players: [Players]", flx*0.53, fly*0.57, flw*0.13, flh*0.025 );
textp.set_rgb( 255, 255, 255 );
textp.align = Align.Left;

// played count text info
local textpc = fe.add_text("Played Count: [PlayedCount]", flx*0.63, fly*0.57, flw*0.13, flh*0.025 );
textpc.set_rgb( 255, 255, 255 );
textpc.align = Align.Left;

// display filter info
local filter = fe.add_text( "Filter: [ListFilterName]", flx*0.84, fly*0.57, flw*0.2, flh*0.025 );
filter.set_rgb( 255, 255, 255 );
filter.align = Align.Left;

// manufacturer filter info
local manufact = fe.add_text( "Manufacturer: [Manufacturer]", flx*0.435, fly*0.6, flw*0.2, flh*0.025 );
manufact.set_rgb( 255, 255, 255 );
manufact.align = Align.Left;

// display game count info
local gamecount = fe.add_text( "Game Count: [ListEntry]-[ListSize]", flx*0.84, fly*0.6, flw*0.5, flh*0.025 );
gamecount.set_rgb( 255, 255, 255 );
gamecount.align = Align.Left;
gamecount.rotation = 0;

// play random sound when transitioning to next / previous game on wheel
function sound_transitions(ttype, var, ttime) 
{
	if (my_config["enable_random_sound"] == "Yes")
	{
		local random_num = floor(((rand() % 1000 ) / 1000.0) * (124 - (1 - 1)) + 1);
		local sound_name = "sounds/GS"+random_num+".mp3";
		switch(ttype) 
		{
		case Transition.EndNavigation:		
			local Wheelclick = fe.add_sound(sound_name);
			Wheelclick.playing=true;
			break;
		}
		return false;
	}
}
fe.add_transition_callback("sound_transitions")
