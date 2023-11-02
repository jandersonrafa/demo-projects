  <script>
import { defineCustomElement } from 'vue';

const Card = defineCustomElement({
  styles: [`
  h2 {
    color: gray;
  }`],
    template:`
      <h2>image teste</h2>
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

customElements.define("my-vue-web-comp2", Card);

export default Card;
</script>