const string c_autoTitleIdPattern = "@nadeo(live)?$";
const auto c_unassigned = MwId(0xffffffff); // SetName("Unassigned")

CGameManiaPlanet@ g_app;
auto g_state = ManiaTitleState();

void ApplyPatch()
{
  if (g_app.LoadedManiaTitle is null || !g_state.CanApply || g_state.IsApplied) {
    return;
  }

  g_app.LoadedManiaTitle.VehicleIdentId = c_unassigned;
  g_app.LoadedManiaTitle.VehicleIdentAuthor = c_unassigned;
  g_app.LoadedManiaTitle.VehicleIdentCollection = c_unassigned;

  g_state.IsApplied = true;

  print("Vehicle unlock applied.");
}

void RevertPatch()
{
  if (g_app.LoadedManiaTitle is null || !g_state.CanApply || !g_state.IsApplied) {
    return;
  }

  g_app.LoadedManiaTitle.VehicleIdentId = g_state.VehicleIdentId;
  g_app.LoadedManiaTitle.VehicleIdentAuthor = g_state.VehicleIdentAuthor;
  g_app.LoadedManiaTitle.VehicleIdentCollection = g_state.VehicleIdentCollection;

  g_state.IsApplied = false;

  print("Vehicle unlock reverted.");
}

void SetStateFromManiaTitle(CGameManiaTitle@ maniaTitle)
{
  g_state = ManiaTitleState(maniaTitle);

  bool canAutoApply = Regex::Contains(g_state.TitleId, c_autoTitleIdPattern);

  if (g_state.CanApply && canAutoApply && !g_state.IsApplied) {
    print("Automatically setting Vehicle unlock for mania title: " + g_state.TitleId);

    ApplyPatch();
  }
}

void Main()
{
  @g_app = cast<CGameManiaPlanet>(GetApp());

  SetStateFromManiaTitle(g_app.LoadedManiaTitle);

  while (true) {
    yield();

    if (g_app.LoadedManiaTitle is null) {
      if (g_state.TitleId != "") {
        SetStateFromManiaTitle(null);
      }

      continue;
    }

    if (g_state.TitleId == g_app.LoadedManiaTitle.TitleId) {
      continue;
    }

    SetStateFromManiaTitle(g_app.LoadedManiaTitle);
  }
}

void OnEnabled()
{
  SetStateFromManiaTitle(g_app.LoadedManiaTitle);
}

void OnDisabled()
{
  RevertPatch();

  g_state = ManiaTitleState();
}

void OnDestroyed()
{
  RevertPatch();
}

void RenderMenu()
{
  if (UI::MenuItem("\\$fc9" + Icons::Car + "\\$z Vehicle unlock", "", g_state.IsApplied, g_state.CanApply)) {
    if (g_state.IsApplied) {
      RevertPatch();
    } else {
      ApplyPatch();
    }
  }
}
