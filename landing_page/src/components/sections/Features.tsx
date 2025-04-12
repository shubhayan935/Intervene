"use client";

import * as React from "react";

export function Features() {
  return (
    <section className="py-20 md:py-32 bg-background">
      <div className="container mx-auto px-4 md:px-6">
        <div className="text-center mb-16">
          <h2 className="text-2xl md:text-4xl font-bold mb-4">Core Features</h2>
          <p className="text-muted-foreground text-lg max-w-2xl mx-auto">
            Just like Tesla Autopilot, you stay in control: touching the mouse or keyboard instantly returns full manual control.
          </p>
        </div>

        {/* Feature 1 */}
        <div className="grid md:grid-cols-2 gap-12 items-center mb-20 md:mb-32">
          <div className="order-2 md:order-1">
            <h3 className="text-2xl font-bold mb-4 text-gradient">Autonomous Mode for Desktop</h3>
            <ul className="space-y-4">
              <li className="flex gap-3">
                <div className="flex-shrink-0 h-6 w-6 rounded-full bg-primary/20 flex items-center justify-center">
                  <div className="h-2 w-2 rounded-full bg-primary"></div>
                </div>
                <p>Run scripted or inferred actions ("rename all these files from this spreadsheet", "extract info from these PDFs and fill a CRM").</p>
              </li>
              <li className="flex gap-3">
                <div className="flex-shrink-0 h-6 w-6 rounded-full bg-primary/20 flex items-center justify-center">
                  <div className="h-2 w-2 rounded-full bg-primary"></div>
                </div>
                <p>Automatically triggers based on context (e.g. open tabs, folders, file names).</p>
              </li>
              <li className="flex gap-3">
                <div className="flex-shrink-0 h-6 w-6 rounded-full bg-primary/20 flex items-center justify-center">
                  <div className="h-2 w-2 rounded-full bg-primary"></div>
                </div>
                <p>Local agent proposes actions, and executes when user confirms or is idle.</p>
              </li>
            </ul>
          </div>
          <div className="order-1 md:order-2 relative">
            <div className="absolute -inset-px rounded-xl bg-gradient-to-r from-primary/20 to-secondary/20 blur"></div>
            <div className="relative bg-card/20 backdrop-blur-sm border border-border/40 rounded-xl overflow-hidden shadow-2xl p-1">
              <img
                src="/autonomous-feature.jpg"
                alt="Autonomous Mode Feature"
                className="w-full rounded-lg aspect-video object-cover bg-black/50"
              />
            </div>
          </div>
        </div>

        {/* Feature 2 */}
        <div className="grid md:grid-cols-2 gap-12 items-center mb-20 md:mb-32">
          <div className="relative">
            <div className="absolute -inset-px rounded-xl bg-gradient-to-r from-secondary/20 to-primary/20 blur"></div>
            <div className="relative bg-card/20 backdrop-blur-sm border border-border/40 rounded-xl overflow-hidden shadow-2xl p-1">
              <img
                src="/takeover-feature.jpg"
                alt="Manual Takeover Feature"
                className="w-full rounded-lg aspect-video object-cover bg-black/50"
              />
            </div>
          </div>
          <div>
            <h3 className="text-2xl font-bold mb-4 text-gradient">Manual Takeover System</h3>
            <ul className="space-y-4">
              <li className="flex gap-3">
                <div className="flex-shrink-0 h-6 w-6 rounded-full bg-primary/20 flex items-center justify-center">
                  <div className="h-2 w-2 rounded-full bg-primary"></div>
                </div>
                <p>Just move the mouse or press any key — agent halts instantly.</p>
              </li>
              <li className="flex gap-3">
                <div className="flex-shrink-0 h-6 w-6 rounded-full bg-primary/20 flex items-center justify-center">
                  <div className="h-2 w-2 rounded-full bg-primary"></div>
                </div>
                <p>Switch back into Copilot Mode via hotkey or voice.</p>
              </li>
            </ul>
          </div>
        </div>

        {/* Feature 3 */}
        <div className="grid md:grid-cols-2 gap-12 items-center mb-20 md:mb-32">
          <div className="order-2 md:order-1">
            <h3 className="text-2xl font-bold mb-4 text-gradient">Memory & Context-Awareness</h3>
            <ul className="space-y-4">
              <li className="flex gap-3">
                <div className="flex-shrink-0 h-6 w-6 rounded-full bg-primary/20 flex items-center justify-center">
                  <div className="h-2 w-2 rounded-full bg-primary"></div>
                </div>
                <p>Remembers past workflows: e.g. "every Monday, generate status report from these folders."</p>
              </li>
              <li className="flex gap-3">
                <div className="flex-shrink-0 h-6 w-6 rounded-full bg-primary/20 flex items-center justify-center">
                  <div className="h-2 w-2 rounded-full bg-primary"></div>
                </div>
                <p>Can personalize agent behavior per user or even per app (Slack vs Figma vs file explorer).</p>
              </li>
            </ul>
          </div>
          <div className="order-1 md:order-2 relative">
            <div className="absolute -inset-px rounded-xl bg-gradient-to-r from-primary/20 to-secondary/20 blur"></div>
            <div className="relative bg-card/20 backdrop-blur-sm border border-border/40 rounded-xl overflow-hidden shadow-2xl p-1">
              <img
                src="/memory-feature.jpg"
                alt="Memory Feature"
                className="w-full rounded-lg aspect-video object-cover bg-black/50"
              />
            </div>
          </div>
        </div>

        {/* Feature 4 */}
        <div className="grid md:grid-cols-2 gap-12 items-center">
          <div className="relative">
            <div className="absolute -inset-px rounded-xl bg-gradient-to-r from-secondary/20 to-primary/20 blur"></div>
            <div className="relative bg-card/20 backdrop-blur-sm border border-border/40 rounded-xl overflow-hidden shadow-2xl p-1">
              <img
                src="/safety-feature.jpg"
                alt="Safety Feature"
                className="w-full rounded-lg aspect-video object-cover bg-black/50"
              />
            </div>
          </div>
          <div>
            <h3 className="text-2xl font-bold mb-4 text-gradient">Safety & Guardrails</h3>
            <ul className="space-y-4">
              <li className="flex gap-3">
                <div className="flex-shrink-0 h-6 w-6 rounded-full bg-primary/20 flex items-center justify-center">
                  <div className="h-2 w-2 rounded-full bg-primary"></div>
                </div>
                <p>Llama Safety API ensures no files/emails/data are sent or altered without local confirmation.</p>
              </li>
              <li className="flex gap-3">
                <div className="flex-shrink-0 h-6 w-6 rounded-full bg-primary/20 flex items-center justify-center">
                  <div className="h-2 w-2 rounded-full bg-primary"></div>
                </div>
                <p>Fully sandboxed with permission checks.</p>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </section>
  );
}
