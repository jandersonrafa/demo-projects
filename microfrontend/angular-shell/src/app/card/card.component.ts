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
  selector: "app-card",
  template: `<div style="margin: 35px">
    <h2 style="color: cadetblue">Card (Vue Microfrontend - Projeto 3)</h2>
    <div>
      Exemplo componente card vue
    </div>
    <span #${containerVueElementName}></span>
  </div>`,
  encapsulation: ViewEncapsulation.None,
})
export class CardComponent {
  @ViewChild(containerVueElementName, { static: true })
  containerVueRef!: ElementRef;

  root!: any;

  name = "name from Angular";

  selected: number = 0;

  constructor(private renderer: Renderer2) {}

  ngAfterViewInit() {
    try {
      import("card_user/Card").then((val) => {
        this.renderer.appendChild(
          this.containerVueRef.nativeElement,
          new val.default()
        );
      });
    } catch {}
  }
}
