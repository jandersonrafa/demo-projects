import {
  Component,
  ElementRef,
  Renderer2,
  ViewChild,
  ViewEncapsulation,
} from "@angular/core";

const containerVueElementName = "customVueComponentContainer";

@Component({
  standalone: true,
  selector: "app-menu",
  template: `<div style="margin: 35px">
    <h2 style="color: cadetblue">Menu (Vue Microfrontend - Projeto 4)</h2>
    <div>
      Exemplo componente menu vue
    </div>
    <span #${containerVueElementName}></span>
  </div>`,
  encapsulation: ViewEncapsulation.None,
})
export class MenuComponent {
  @ViewChild(containerVueElementName, { static: true })
  containerVueRef!: ElementRef;

  root!: any;

  name = "name from Angular";

  selected: number = 0;

  constructor(private renderer: Renderer2) {}

  ngAfterViewInit() {
    try {
      import("menu_user/Menu").then((val) => {
        this.renderer.appendChild(
          this.containerVueRef.nativeElement,
          new val.default()
        );
      });
    } catch {}
  }
}
