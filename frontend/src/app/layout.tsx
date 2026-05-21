import type { Metadata } from "next";
import React from "react";
import Navbar from "./components/Navbar";
import "./globals.css";

export const metadata: Metadata = {
  title: "Plateforme d'Apprentissage - EduMaster",
  description: "Apprenez, progressez et excellez avec notre plateforme d'apprentissage en ligne innovante",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="fr" suppressHydrationWarning>
      <body className="min-h-screen bg-background font-sans">
        <div className="relative flex min-h-screen flex-col">
          <Navbar />
          <main className="flex-1">{children}</main>
          <footer className="border-t bg-gradient-to-b from-slate-50 to-slate-100">
            <div className="mx-auto max-w-7xl px-4 py-12 sm:px-6 lg:px-8">
              <div className="grid grid-cols-1 gap-8 sm:grid-cols-3">
                <div>
                  <h3 className="mb-3 text-sm font-semibold tracking-wider uppercase text-slate-900">EduMaster</h3>
                  <ul className="space-y-2 text-sm text-slate-600">
                    <li><a href="/courses" className="transition-colors hover:text-teal-600">Explorer les cours</a></li>
                    <li><a href="/dashboard" className="transition-colors hover:text-teal-600">Tableau de bord</a></li>
                  </ul>
                </div>
                <div>
                  <h3 className="mb-3 text-sm font-semibold tracking-wider uppercase text-slate-900">Ressources</h3>
                  <ul className="space-y-2 text-sm text-slate-600">
                    <li><a href="/auth/register" className="transition-colors hover:text-teal-600">Commencer</a></li>
                    <li><a href="/auth/login" className="transition-colors hover:text-teal-600">Se connecter</a></li>
                  </ul>
                </div>
                <div>
                  <h3 className="mb-3 text-sm font-semibold tracking-wider uppercase text-slate-900">À propos</h3>
                  <p className="text-sm text-slate-600 leading-relaxed">
                    Plateforme d'apprentissage innovante avec IA intégrée, construite avec une architecture microservices. Projet Master DevOps & Cloud.
                  </p>
                </div>
              </div>
              <div className="mt-8 border-t border-slate-200 pt-6 text-center text-sm text-slate-500">
                © {new Date().getFullYear()} EduMaster. Tous droits réservés.
              </div>
            </div>
          </footer>
        </div>
      </body>
    </html>
  );
}
