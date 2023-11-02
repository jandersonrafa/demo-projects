  <script>
import { defineCustomElement } from 'vue';

const Settings = defineCustomElement({
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
      <fieldset>
        <legend>Notification settings: {{selected == 0 ? 'Opção 1' : 'Opção 2'}}</legend>

        <div>
          <input type="radio" value="0" v-model="selected">
          <label>Opção 1</label>
        </div>

        <div>
          <input type="radio" value="1" v-model="selected">
          <label>Opção 2</label>
        </div>

        <button @click="onClick(selected)">Submit</button>
     </fieldset>
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

customElements.define("my-vue-web-comp", Settings);

export default Settings;
</script>