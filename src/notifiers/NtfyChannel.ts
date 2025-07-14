import fetch from "node-fetch";
import { Notifier } from "./Notifier.js";
import { Game } from "../games/Game.js";
import { NtfySettings } from "../configs/types/types.js";

export class NtfyChannel extends Notifier {
  private settings: NtfySettings;

  constructor(settings: NtfySettings) {
    super();
    this.settings = settings;
  }

  async send(game: Game): Promise<void> {
    //const url = `${this.settings.url}/${this.settings.topic}`; 
    const url = `${this.settings.url}/${this.settings.topic}${this.settings.token ? `?auth=${this.settings.token}` : ''}`;
    const encodedTitle = `=?UTF-8?B?${Buffer.from(game.title).toString("base64")}?=`;

    try {
      const response = await fetch(url, {
        method: "POST",
        body: "Free game available! Click to claim.",
        headers: {
          Title: encodedTitle,
          Click: game.url,
          Attach: game.iconUrl,
          Actions: `view, Claim, ${game.url}`,
        },
      });

      if (!response.ok) {
        throw new Error(`Failed to send notification: ${response.statusText}`);
      }

      this.logSuccess();
    } catch (error) {
      this.logError(error);
      throw error;
    }
  }
}
