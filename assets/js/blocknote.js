import "@blocknote/core/fonts/inter.css";
import { BlockNoteView } from "@blocknote/mantine";
import "@blocknote/mantine/style.css";
import { useCreateBlockNote } from "@blocknote/react";
import React from "react";
import * as Y from "yjs";
import CustomProvider from "./custom_provider";

const doc = new Y.Doc();
const provider = new CustomProvider("/doc_updates", doc);

export default function App() {
  const editor = useCreateBlockNote({
    collaboration: {
      provider,
      fragment: doc.getXmlFragment("document-store"),
      user: {
        name: "My User",
        color: "#ff0000",
      },
    },
  });

  return <BlockNoteView editor={editor} />;
}
