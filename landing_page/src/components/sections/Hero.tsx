"use client";

import * as React from "react";
import { Button } from "@/components/ui/button";
import Link from "next/link";

export function Hero() {
  return (
    <section className="relative pt-32 pb-16 md:pt-40 md:pb-24 bg-superhuman-gradient overflow-hidden">
      <div className="absolute inset-0 bg-[url('/grid-pattern.svg')] bg-center [mask-image:linear-gradient(to_bottom,white,transparent)]"></div>
      <div className="container mx-auto relative z-10 px-4 md:px-6 text-center">
        <div className="max-w-3xl mx-auto">
          <h1 className="text-3xl md:text-5xl font-bold mb-6 leading-tight">
            Tesla Autopilot for desktops
          </h1>
          <p className="text-lg md:text-xl text-muted-foreground mb-8 leading-relaxed max-w-2xl mx-auto">
            Robin AI is an on-device autonomous desktop agent that takes over repetitive digital workflows — filling forms, renaming files, drafting emails, organizing tabs, etc.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <Button asChild className="bg-primary hover:bg-primary/90 text-white font-medium px-6 py-6 h-auto rounded-md">
              <Link href="/try">
                Try Intervene
              </Link>
            </Button>
            <Button asChild variant="outline" className="border-muted hover:border-white text-white hover:bg-background/10 font-medium px-6 py-6 h-auto rounded-md">
              <Link href="/demo">
                Watch Demo
              </Link>
            </Button>
          </div>
        </div>

        <div className="mt-16 md:mt-24 relative">
          <div className="absolute -inset-px rounded-xl bg-gradient-to-r from-primary/20 to-secondary/20 blur"></div>
          <div className="bg-card/20 backdrop-blur-sm border border-border/40 rounded-xl overflow-hidden shadow-2xl">
            <video
              className="w-full aspect-video object-cover"
              autoPlay
              loop
              muted
              poster="/dashboard-preview.jpg"
            >
              <source src="/dashboard-preview.mp4" type="video/mp4" />
              Your browser does not support the video tag.
            </video>
          </div>
          <div className="flex justify-center mt-8 gap-8 flex-wrap">
            <img src="https://ext.same-assets.com/1144366762/889714044.png" alt="Client logo" className="h-8 opacity-50 hover:opacity-80 transition-opacity" />
            <img src="https://ext.same-assets.com/1144366762/98440472.png" alt="Client logo" className="h-8 opacity-50 hover:opacity-80 transition-opacity" />
            <img src="https://ext.same-assets.com/1144366762/485429720.png" alt="Client logo" className="h-8 opacity-50 hover:opacity-80 transition-opacity" />
            <img src="https://ext.same-assets.com/1144366762/115214406.png" alt="Client logo" className="h-8 opacity-50 hover:opacity-80 transition-opacity" />
            <img src="https://ext.same-assets.com/1144366762/3886524102.png" alt="Client logo" className="h-8 opacity-50 hover:opacity-80 transition-opacity" />
          </div>
        </div>
      </div>
    </section>
  );
}
