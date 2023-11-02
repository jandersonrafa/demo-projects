import { NgModule } from "@angular/core";

import { ProfileUserComponent } from "src/app/profile-user/profile-user.component";
import { ProfileUserService } from "../profile-user/profile-user.service";
import { SettingsComponent } from "../settings/settings.component";
import { MenuComponent } from "../menu/menu.component";
import { CardComponent } from "../card/card.component";

@NgModule({
  imports: [ProfileUserComponent, SettingsComponent, MenuComponent, CardComponent],
  providers: [ProfileUserService],
})
export class LayoutModule {}
