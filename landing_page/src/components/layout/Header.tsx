"use client";

import * as React from "react";
import Link from "next/link";
import { Button } from "@/components/ui/button";

export function Header() {
  return (
    <header className="fixed top-0 left-0 right-0 z-50 bg-background/80 backdrop-blur-md border-b border-border/20">
      <div className="container mx-auto px-4 md:px-6 py-4 flex items-center justify-between">
        <div className="flex items-center gap-8">
          <Link href="/" className="flex items-center gap-2">
            <span className="font-bold text-xl text-white">Intervene</span>
          </Link>
          <nav className="hidden md:flex items-center gap-6">
            <Link href="/product" className="text-sm text-muted-foreground hover:text-white transition-colors">
              Product
            </Link>
            <Link href="/resources" className="text-sm text-muted-foreground hover:text-white transition-colors">
              Resources
            </Link>
            <Link href="/pricing" className="text-sm text-muted-foreground hover:text-white transition-colors">
              Pricing
            </Link>
          </nav>
        </div>
        <div className="flex items-center gap-4">
          <Link href="/love" className="hidden md:flex text-sm text-muted-foreground hover:text-white transition-colors">
            Love
          </Link>
          <Button variant="default" className="bg-primary hover:bg-primary/90 text-white">Get Started</Button>
        </div>
      </div>
    </header>
  );
}
