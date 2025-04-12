"use client";

import * as React from "react";
import { Button } from "@/components/ui/button";
import Link from "next/link";

export function CTA() {
  return (
    <section className="py-16 md:py-24 relative overflow-hidden">
      <div className="absolute inset-0 bg-gradient-to-b from-background via-background/80 to-background/60"></div>
      <div className="container mx-auto px-4 md:px-6 relative z-10">
        <div className="max-w-5xl mx-auto bg-card/30 border border-border/30 rounded-xl backdrop-blur-md p-8 md:p-12">
          <div className="text-center mb-10">
            <h2 className="text-2xl md:text-4xl font-bold mb-6">Get started with Intervene</h2>
            <p className="text-lg text-muted-foreground max-w-3xl mx-auto mb-8">
              Experience the power of an on-device autonomous desktop agent that takes over repetitive digital workflows. Save hours every week.
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <Button asChild className="bg-primary hover:bg-primary/90 text-white font-medium px-6 py-6 h-auto rounded-md">
                <Link href="/try">
                  Get Started
                </Link>
              </Button>
              <Button asChild variant="outline" className="border-muted hover:border-white text-white hover:bg-background/10 font-medium px-6 py-6 h-auto rounded-md">
                <Link href="/demo">
                  Talk to Sales
                </Link>
              </Button>
            </div>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div className="flex flex-col items-center text-center p-4">
              <div className="w-12 h-12 rounded-full bg-primary/20 flex items-center justify-center mb-4">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="text-primary">
                  <path d="M6 18h8"></path>
                  <path d="M3 22h18"></path>
                  <path d="M14 22a7 7 0 1 0 0-14h-1"></path>
                  <path d="M9 14h2"></path>
                  <path d="M9 12a2 2 0 0 1-2-2V6a2 2 0 0 1 4 0v4a2 2 0 0 1-2 2Z"></path>
                </svg>
              </div>
              <h3 className="text-lg font-medium mb-2">Fully Local</h3>
              <p className="text-muted-foreground text-sm">All processing happens on your machine for ultimate privacy.</p>
            </div>
            <div className="flex flex-col items-center text-center p-4">
              <div className="w-12 h-12 rounded-full bg-primary/20 flex items-center justify-center mb-4">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="text-primary">
                  <path d="M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z"></path>
                  <path d="M9 12h6"></path>
                </svg>
              </div>
              <h3 className="text-lg font-medium mb-2">Easy Setup</h3>
              <p className="text-muted-foreground text-sm">Install in minutes with no complex configuration required.</p>
            </div>
            <div className="flex flex-col items-center text-center p-4">
              <div className="w-12 h-12 rounded-full bg-primary/20 flex items-center justify-center mb-4">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="text-primary">
                  <rect width="18" height="18" x="3" y="3" rx="2"></rect>
                  <path d="M7 7h10"></path>
                  <path d="M7 12h10"></path>
                  <path d="M7 17h10"></path>
                </svg>
              </div>
              <h3 className="text-lg font-medium mb-2">Team Integration</h3>
              <p className="text-muted-foreground text-sm">Works with your existing tools and workflows.</p>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
