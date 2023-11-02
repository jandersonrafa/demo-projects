<script>
import Settings from "./components/Settings.vue";
import Card from "./components/Card.vue";

export default {
  template: `<h1>Vue component</h1>`
}

document.body.appendChild(new Settings());
document.body.appendChild( new Card());
</script>