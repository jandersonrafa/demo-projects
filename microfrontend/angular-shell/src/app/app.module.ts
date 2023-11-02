import {
  NgModule,
  APP_INITIALIZER,
  CUSTOM_ELEMENTS_SCHEMA,
} from "@angular/core";
import { BrowserModule } from "@angular/platform-browser";
import { RouterModule, Routes } from "@angular/router";

import { loadRemoteModule } from "./utils/federation-utils";
import { AppComponent } from "./app.component";

const routes: Routes = [
  {
    path: "",
    loadComponent: () =>
      import("./layout/layout.component").then((m) => m.LayoutComponent),
  },
  {
    path: "profile-user",
    loadComponent: () =>
      import("./profile-user/profile-user.component").then(
        (m) => m.ProfileUserComponent
      ),
  },
  {
    path: "settings",
    loadComponent: () =>
      import("./settings/settings.component").then((m) => m.SettingsComponent),
  },
  {
    path: "menu",
    loadComponent: () =>
      import("./menu/menu.component").then((m) => m.MenuComponent),
  },
  {
    path: "card",
    loadComponent: () =>
      import("./card/card.component").then((m) => m.CardComponent),
  },
];

export function initializeApp(): () => void {
  return () => {
    loadRemoteModule({
      remoteEntry: "http://localhost:3001/remoteEntry.js",
      remoteName: "profile_user",
      exposedModule: "./ProfileReactComponent",
    });
    loadRemoteModule({
      remoteEntry: "http://localhost:3002/remoteEntry.js",
      remoteName: "settings_user",
      exposedModule: "./Settings",
    });
    loadRemoteModule({
      remoteEntry: "http://localhost:3003/remoteEntry.js",
      remoteName: "menu_user",
      exposedModule: "./Menu",
    });
    loadRemoteModule({
      remoteEntry: "http://localhost:3002/remoteEntryCard.js",
      remoteName: "card_user",
      exposedModule: "./Card",
    });
  };
}

@NgModule({
  declarations: [AppComponent],
  imports: [BrowserModule, RouterModule.forRoot(routes)],
  providers: [
    {
      provide: APP_INITIALIZER,
      useFactory: initializeApp,
      multi: true,
    },
  ],
  schemas: [
    CUSTOM_ELEMENTS_SCHEMA, // Added for custom elements support
  ],

  bootstrap: [AppComponent],
})
export class AppModule {}
