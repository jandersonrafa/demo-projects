  <script>
import { defineCustomElement } from 'vue';

const Menu = defineCustomElement({
  styles: [`
  fieldset {
    line-height: 1.9;
    font-family: Inter, sans-serif; 
  }
  button {
    margin-top: 10px;
  }
  label {
    margin-left: 7px;
  }`],
    template:`
      <div>
        <table>
          <tr>
            <td>Menu 1</td>
            <td>Menu 2</td>
            <td>Menu 3</td>
          </tr>
        </table>
      </div>
    `,
    data() {
      return {
        selected: 0
      };
    },
    methods: {
      onClick(selected) {
        console.log(`Vue component: selected option - ${selected}.`);
      },
    },
  });

customElements.define("my-vue-web-comp", Menu);

export default Menu;
</script>