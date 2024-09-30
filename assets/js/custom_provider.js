import { Socket } from "phoenix";
import * as Y from "yjs";
import { Observable } from "lib0/observable";

export default class CustomProvider extends Observable {
  constructor(endpoint, doc) {
    super();
    this.doc = doc;
    this.sock = new Socket(endpoint);
    this.chan = this.sock.channel("doc:1");

    this.sock.onOpen(() => {
      this.chan.join();
      this.chan
        .push("get_update_for_load", Y.encodeStateVector(this.doc).buffer)
        .receive("ok", (update) =>
          Y.applyUpdate(this.doc, new Uint8Array(update)),
        );
    });

    this.chan.on("apply_update", (payload, origin) => {
      payload = new Uint8Array(payload);
      Y.applyUpdate(this.doc, payload);
    });

    this.sock.connect();

    this.doc.on("update", (update, orig) => {
      this.chan.push("update", update.buffer);
    });
  }
}
