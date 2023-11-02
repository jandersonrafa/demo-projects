import { Component } from "@angular/core";
import { ProfileUserComponent } from "../profile-user/profile-user.component";
import { SettingsComponent } from "../settings/settings.component";
import { MenuComponent } from "../menu/menu.component";
import { CardComponent } from "../card/card.component";

@Component({
  standalone: true,
  imports: [SettingsComponent, ProfileUserComponent, MenuComponent, CardComponent],
  selector: "app-layout",
  template: `<app-menu></app-menu><app-profile-user></app-profile-user>
    <app-settings></app-settings><app-card></app-card>`,
})
export class LayoutComponent {}
