import Menu from '../menu.svelte';
import Switcher from '../switcher.svelte';
import WebpackerSvelte from "webpacker-svelte";
import Turbolinks from "turbolinks";

Turbolinks.start();
WebpackerSvelte.setup({ Menu, Switcher });