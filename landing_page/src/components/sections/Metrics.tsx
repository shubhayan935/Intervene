"use client";

import * as React from "react";

export function Metrics() {
  return (
    <section className="py-20 md:py-28 bg-gradient-to-b from-background to-background/90">
      <div className="container mx-auto px-4 md:px-6">
        <div className="flex flex-col items-center">
          <div className="w-20 h-20 rounded-full bg-primary/20 flex items-center justify-center mb-8">
            <div className="w-12 h-12 text-4xl font-bold text-primary">60%</div>
          </div>
          <h2 className="text-2xl md:text-4xl font-bold mb-6 text-center">
            Intervene saves teams millions of hours every single year
          </h2>
          <p className="text-lg text-muted-foreground text-center max-w-2xl mb-16">
            Our quantifiable edge delivers real results for teams of all sizes.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div className="bg-card/30 border border-border/30 rounded-lg p-6 text-center backdrop-blur-sm">
            <div className="text-3xl md:text-4xl font-bold mb-2 text-gradient">60%</div>
            <p className="text-muted-foreground">Faster completion of repetitive workflows</p>
          </div>

          <div className="bg-card/30 border border-border/30 rounded-lg p-6 text-center backdrop-blur-sm">
            <div className="text-3xl md:text-4xl font-bold mb-2 text-gradient">45%</div>
            <p className="text-muted-foreground">Reduces context switching</p>
          </div>

          <div className="bg-card/30 border border-border/30 rounded-lg p-6 text-center backdrop-blur-sm">
            <div className="text-3xl md:text-4xl font-bold mb-2 text-gradient">100%</div>
            <p className="text-muted-foreground">Actions done locally with no cloud access</p>
          </div>
        </div>
      </div>
    </section>
  );
}
