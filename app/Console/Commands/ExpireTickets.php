<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;

class ExpireTickets extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'app:expire-tickets';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Command description';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $expiredTickets = Ticket::where('expired_at', '<', now())
            ->where('status', 'active')
            ->update(['status' => 'expired']);
    
        $this->info("Tiket expired diupdate: {$expiredTickets}");
    }
}
