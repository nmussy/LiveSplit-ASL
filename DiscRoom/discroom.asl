state("DISC ROOM") {
  double mapX: 0x0044330C, 0x500, 0xC, 0x2C, 0x10, 0xB70,  0x0;
  double mapY: 0x0044330C, 0x500, 0xC, 0x2C, 0x10, 0x7C8,  0x0;
  double igt:  0x0044330C, 0x500, 0xC, 0x2C, 0x10, 0x1368, 0x0;
}

startup {
  settings.Add("keepers", true, "Split after accessing a zone unlocked by defeating a Gatekeeper:");
  settings.Add("normal", true, "Split when first entering a room:");
  settings.Add("north", true, "North area", "normal");
  settings.Add("middle", true, "Middle area", "normal");
  settings.Add("west", true, "West area", "normal");
  settings.Add("east", true, "East area", "normal");
  settings.Add("south", true, "South area", "normal");

  settings.Add("armored", true, "Armored Gatekeeper", "keepers");
  settings.Add("overgrown", true, "Overgrown Gatekeeper", "keepers");
  settings.Add("carnivorous", true, "Carnivorous Gatekeeper", "keepers");
  settings.Add("phantom", true, "Phantom Gatekeeper", "keepers");
  settings.Add("ultimate", true, "Ultimate Gatekeeper", "keepers");

  settings.Add("9,14",  false, "On your Feet", "north");
  settings.Add("10,14", false, "Disc Room", "north");
  settings.Add("11,14", false, "Stay Sharp", "north");

  settings.Add("9,13",  false, "Close Encounters", "north");
  settings.Add("10,13", false, "Cut up", "north");
  settings.Add("11,13", false, "Get a Room", "north");

  settings.Add("8,12",  false, "Rare Element", "west");
  settings.Add("9,12",  false, "Blades Runner", "north");
  settings.Add("10,12", false, "Armored Gatekeeper", "north");
  settings.Add("11,12", false, "The Challenge", "north");
  settings.Add("12,12", false, "Star Map", "north");

  settings.Add("6,11",  false, "Carnivorous Gatekeeper", "west");
  settings.Add("7,11",  false, "The Aging Process", "west");
  settings.Add("8,11",  false, "Lobotomy", "west");
  settings.Add("9,11",  false, "Carrousel", "middle");
  settings.Add("10,11", false, "Greenhouse", "middle");
  settings.Add("11,11", false, "The Grass is Greener", "middle");
  settings.Add("12,11", false, "Discomfort", "east");
  settings.Add("13,11", false, "Perfect Dark", "east");
  settings.Add("14,11", false, "Great Red Spot", "east");

  settings.Add("6,10",  false, "Brutal Antibody", "west");
  settings.Add("7,10",  false, "Rotted Antibody", "west");
  settings.Add("8,10",  false, "First Blood", "west");
  settings.Add("9,10",  false, "Shredded", "middle");
  settings.Add("10,10", false, "Overgrown Gatekeeper", "middle");
  settings.Add("11,10", false, "Bunch of Jerks", "middle");
  settings.Add("12,10", false, "Infrared", "east");
  settings.Add("13,10", false, "Heart of Darkness", "east");
  settings.Add("14,10", false, "Phantom Gatekeeper", "east");

  settings.Add("6,9",  false, "Golden Carcass", "west");
  settings.Add("7,9",  false, "Ravenous Antibody", "west");
  settings.Add("8,9",  false, "Toxic Antibody", "west");
  settings.Add("9,9",  false, "A Change of Pace", "middle");
  settings.Add("10,9", false, "Can't Touch This", "middle");
  settings.Add("11,9", false, "Natural Selection", "middle");
  settings.Add("12,9", false, "Event Horizon", "east");
  settings.Add("13,9", false, "Timeless", "east");
  settings.Add("14,9", false, "The Path", "east");

  settings.Add("8,8",  false, "Gold Frequency", "south");
  settings.Add("9,8",  false, "It's Just a Phase", "south");
  settings.Add("10,8", false, "Jupiter Ascending", "south");
  settings.Add("11,8", false, "Scientific Method", "south");
  settings.Add("12,8", false, "Binary Orbit", "east");

  settings.Add("9,7",  false, "Safety First", "south");
  settings.Add("10,7", false, "Again", "south");
  settings.Add("11,7", false, "Danger Zone", "south");

  settings.Add("9,6",  false, "Homesick", "south");
  settings.Add("10,6", false, "Cut up", "south");
  settings.Add("11,6", false, "Ultimate Gatekeeper", "south");

}

init {
  vars.bosses = new Dictionary<string, int[]>();
  vars.bosses.Add("armored", new []{10, 11});
  vars.bosses.Add("overgrown", new []{9, 10});
  vars.bosses.Add("carnivorous", new []{12, 10});
  vars.bosses.Add("phantom", new []{10, 8});
  vars.bosses.Add("ultimate", new []{30, 7});

  vars.unlocks = new Dictionary<string, bool>();
}

start {
  if (old.igt == 0 && current.igt > 0 && current.igt < 5) {
    vars.unlocks = new Dictionary<string, bool>();
    return true;
  }
}

reset {
  return current.igt == 0 && old.igt > 0;
}

split {
  if(current.mapX == old.mapX && current.mapY == old.mapY) {
    return false;
  }

  bool res = false;
  string position = current.mapX + "," + current.mapY;
  if (!vars.unlocks.ContainsKey(position)) {
      vars.unlocks[position] = true;
    res = settings[position];
  }

  foreach (string keeper in vars.bosses.Keys) {
    if (
      current.mapX == vars.bosses[keeper][0] &&
      current.mapY == vars.bosses[keeper][1] &&
      !vars.unlocks.ContainsKey(keeper)
    ) {
      vars.unlocks[keeper] = true;
      res = res || settings[keeper];
    }
  }

  return res;
}

isLoading {
  return true;
}

gameTime {
  if (current.igt > 0 && current.igt < Int64.MaxValue) return TimeSpan.FromSeconds(current.igt / 60);
}