state("DISC ROOM") {
  double mapX: 0x0044330C, 0x500, 0xC, 0x2C, 0x10, 0xB70, 0x0;
  double mapY: 0x0044330C, 0x500, 0xC, 0x2C, 0x10, 0x7C8, 0x0;
  double igt: 0x0044330C, 0x500, 0xC, 0x2C, 0x10, 0x1368, 0x0;
}

startup {
  settings.Add("keepers", true, "Split after accessing a zone unlocked by defeating a Gatekeeper:");

  settings.CurrentDefaultParent = "keepers";
  settings.Add("armored", true, "Armored Gatekeeper");
  settings.Add("overgrown", true, "Overgrown Gatekeeper");
  settings.Add("carnivorous", true, "Carnivorous Gatekeeper");
  settings.Add("phantom", true, "Phantom Gatekeeper");
  settings.Add("ultimate", true, "Ultimate Gatekeeper");
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
  foreach (string keeper in vars.bosses.Keys) {
    if (
      current.mapX == vars.bosses[keeper][0] &&
      current.mapY == vars.bosses[keeper][1] &&
      !vars.unlocks.ContainsKey(keeper)
    ) {
      vars.unlocks[keeper] = true;
      return settings[keeper];
    }
  }

  return false;
}

isLoading {
  return true;
}

gameTime {
  if (current.igt > 0 && current.igt < Int64.MaxValue) return TimeSpan.FromSeconds(current.igt / 60);
}