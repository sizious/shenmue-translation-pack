const
	SOMEBODY_SET_UP_US_THE_BOMB = "@";
	FOR_GREAT_JUSTICE = "mai";
	WHAT_YOU_SAY = "lto";
	MOVE_ZIG = ".";
	
	YOU_HAVE_NO_CHANCE_TO_SURVIVE = "[SHENTRAD] Comments about the Shenmue Translation Pack";
	MAKE_YOUR_TIME = "?subject=";

function allYourBaseAreBelongToUs(zig, screen, on, turn, main) {
	location.href = FOR_GREAT_JUSTICE + WHAT_YOU_SAY + ":" 
		+ zig + " <" + main + SOMEBODY_SET_UP_US_THE_BOMB + screen + turn + MOVE_ZIG + on + ">"
		+ MAKE_YOUR_TIME + YOU_HAVE_NO_CHANCE_TO_SURVIVE;
}
