class ManiaTitleState
{
  string TitleId;
  bool CanApply;
  MwId VehicleIdentId;
  MwId VehicleIdentAuthor;
  MwId VehicleIdentCollection;
  bool IsApplied = false;

  ManiaTitleState()
  {
    TitleId = "";
    CanApply = false;
    VehicleIdentId = MwId();
    VehicleIdentAuthor = MwId();
    VehicleIdentCollection = MwId();
  }

  ManiaTitleState(CGameManiaTitle@ title)
  {
    if (title is null) {
      ManiaTitleState();
    } else {
      TitleId = title.TitleId;
      CanApply = title.VehicleIdentId.GetName() != "Unassigned";
      VehicleIdentId = title.VehicleIdentId;
      VehicleIdentAuthor = title.VehicleIdentAuthor;
      VehicleIdentCollection = title.VehicleIdentCollection;
    }
  }
}
